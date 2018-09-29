//
//  MovieSelectionViewController.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import UIKit
import SDWebImage

class MovieSelectionViewController: UIViewController{
    
    // Attributes
    internal var selectedMovie: Movie?
    internal var selectedMoviePoster: UIImage?
    
    // Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterLbl: UILabel!
    @IBOutlet weak var titleTypeLbl: UILabel!
    @IBOutlet weak var titleAgeLbl: UILabel!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailHUD: UIVisualEffectView!
    
    //    MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadContent()
    }
    
    //    MARK: Initializer
    private func setupView(){
        showIndicator(visible: false)
//        self.titleTypeLbl.layer.cornerRadius = 10
//        self.titleAgeLbl.layer.cornerRadius = 10
        
        // setup full screen toggle
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen)))
    }
    
    private func showIndicator(visible: Bool){
        self.imageLoadingIndicator.isHidden = !visible
        if visible{
            self.imageLoadingIndicator.startAnimating()
        }
        else{
            self.imageLoadingIndicator.stopAnimating()
        }
    }
    
    //MARK: Update content
    private func loadContent(){
//        posterImageView.image = UIImage(named: "poster")
        if let movie = selectedMovie{
            self.title = movie.title
            self.posterLbl.text = movie.title
            self.titleTypeLbl.text = movie.type
            self.titleAgeLbl.text = DateHelper.calculateYearAgo(year: movie.year ?? "")
            if let imageURLStr = movie.poster/*, imageURLStr != "N/A"*/{
                self.showIndicator(visible: true)
                self.posterImageView.sd_setImage(with: URL(string: imageURLStr)!, placeholderImage: UIImage(named: "poster"), options: .cacheMemoryOnly) { (_, _, _, _) in
                    self.showIndicator(visible: false)
                }
            }
        }
//        if let selectedMoviePoster = selectedMoviePoster{
//            self.posterImageView.image = selectedMoviePoster
//        }
    }

    @objc func toggleFullScreen(){
        
        UIView.animate(withDuration: 0.6, animations: {
            let isFullScreen = (0 != self.detailHUD.alpha)
            // toggle background color
            self.view.backgroundColor = isFullScreen ? .black : .white
            self.posterImageView.backgroundColor = isFullScreen ? .black : .white
            //toggle view visibility
            if isFullScreen{
                self.detailHUD.alpha = 0
                self.detailHUD.alpha = 0
            }
            else{
                self.detailHUD.alpha = 1
                self.detailHUD.alpha = 1
            }
            // Toggle navigation bar
            self.navigationController?.setNavigationBarHidden(!self.navigationController!.isNavigationBarHidden, animated: false)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
}
