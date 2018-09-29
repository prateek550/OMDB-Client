//
//  SearchRouter.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

typealias SearchResponse = (searchBase: MovieBase?, error: Error?)

struct SearchRouter{
    
    /*
     * @discussion This method searches for movies
     * @param keyword: search keyword
     * @param pageNumber: search result page
     */
    static func fetchSearchResults(keyword: String, pageNumber: Int, completion: @escaping (SearchResponse)->Void){
        
        let params = [URLParameters.getSearchParam(searchString: keyword),
                      URLParameters.getPage(pageNumber: pageNumber)]
        NetworkHelper.fetchRequest(requestParams: params) { (response) in
            
            if let data = response.data{
                let searchBase = try? JSONDecoder().decode(MovieBase.self, from: data)
                completion((searchBase, nil))
            }
            else{
                completion((nil, response.error))
            }
        }
    }
}
