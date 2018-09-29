//
//  URLParameters.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

//http://www.omdbapi.com/?s=Batman&page=1&apikey=eeefc96f

struct URLParameters{
    
    static func getPage(pageNumber:Int)->URLQueryItem{
//        let key = "&page="
//        return key.appending(String(describing: pageNumber))
        return URLQueryItem(name: "page", value: String(describing: pageNumber))
    }
    
    static func getSearchParam(searchString:String)->URLQueryItem{
//        let key = "&s="
//        return key.appending(searchString)
        return URLQueryItem(name: "s", value: searchString)
    }
    
}
