//
//  MoviePosterViewController.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import UIKit
import SDWebImage

class MoviePosterViewController: UICollectionViewController {

    // Attributes
    private let SEARCH_KEYWORD = "Batman"
    private let MOVIE_CELL_IDENTIFIER = "moviePosterCell"
    private let LOADING_FOOTER_IDENTIFIER = "loadingFooter"
    private let CELLS_PER_LINE: Int = 2
    private var currentPage = 1
    private var totalResults = 1
    private var movies = [Movie]()
    
    private var intrimSpacing: CGFloat{
        return 5
    }
    
    private var expectedWidth: CGFloat{
        return ((self.view.frame.width - (self.intrimSpacing * CGFloat(CELLS_PER_LINE - 1))) / CGFloat(CELLS_PER_LINE)) - (intrimSpacing)
    }
    
    private var expectedHeight: CGFloat{
        return  min(2 * expectedWidth, (0.80 * self.view.frame.height))
    }
    
    //    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Catalog"
        loadMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //    MARK: Orientation
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //    MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectionVC = segue.destination as? MovieSelectionViewController{
            selectionVC.selectedMovie = movies[self.collectionView.indexPathsForSelectedItems!.first!.row]
        }
    }
    
    //    MARK: Fetch movies
    private func loadMovies(){
        if totalResults >= currentPage{
            SearchRouter.fetchSearchResults(keyword: SEARCH_KEYWORD, pageNumber: currentPage, completion: loadMoviesResult(responseData: ))
        }
    }
    
    private func loadMoviesResult(responseData: SearchResponse){
        if let searchBase = responseData.searchBase{
            self.totalResults = Int(searchBase.totalResults!) ?? 0
            if let movies = searchBase.movies, movies.count > 0{
                self.movies.append(contentsOf: movies)
                self.currentPage += 1
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension MoviePosterViewController{
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: cell navigation
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > (movies.count - CELLS_PER_LINE){
            self.loadMovies()
        }
    }
}

// MARK: UICollectionViewDataSource
extension MoviePosterViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MOVIE_CELL_IDENTIFIER, for: indexPath)
        let movie = movies[indexPath.row]
        
        // image
        let posterImg = movieCell.viewWithTag(100) as! UIImageView
        if let imageURLStr = movie.poster{
            posterImg.sd_setImage(with: URL(string: imageURLStr), placeholderImage: UIImage(named: "poster"), options: .cacheMemoryOnly, progress: nil, completed: nil)
        }
        // title
        let posterTitle = movieCell.viewWithTag(101) as! UILabel
        posterTitle.text = movie.title
        
        // year
        let titleYear = movieCell.viewWithTag(102) as! UILabel
        titleYear.text = DateHelper.calculateYearAgo(year: movie.year ?? "")
        
        // type
        let titleType = movieCell.viewWithTag(103) as! UILabel
        titleType.text = movie.type
//        titleType.layer.cornerRadius = 10
        
        movieCell.layer.cornerRadius = 5
        
        return  movieCell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LOADING_FOOTER_IDENTIFIER, for: indexPath)
        
        let indicator = reusableFooter.viewWithTag(100) as! UIActivityIndicatorView
        let label = reusableFooter.viewWithTag(101) as! UILabel
        if movies.count == totalResults{
            indicator.stopAnimating()
            label.isHidden = false
        }
        else{
            indicator.startAnimating()
            label.isHidden = true
        }
        
        return reusableFooter
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension MoviePosterViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: expectedWidth, height: expectedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return intrimSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return intrimSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: intrimSpacing, left: intrimSpacing, bottom: intrimSpacing, right: intrimSpacing)
    }
}
