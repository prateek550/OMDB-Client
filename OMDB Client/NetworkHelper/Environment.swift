//
//  Environment.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

//http://www.omdbapi.com/?s=Batman&page=1&apikey=eeefc96f

/// Helps creating base url for the seleceted environment.
enum Environment{
    
    // One and only !!
    case DEVELOPMENT
    // TODO: Add more environments in future. Also update corresponding properties & functions
    case UNKNOWN
    
    private static let CONFIG_PLIST = "Config"
    
    static func getDefaultEnvironment()->Environment{
        guard let configPlistPath = Bundle.main.path(forResource: Environment.CONFIG_PLIST, ofType: ".plist") else {  return .UNKNOWN   }
        if let contentsOfPlist = NSDictionary(contentsOfFile: configPlistPath){
            if let environments = contentsOfPlist.value(forKey: "Environment") as? [String:Bool]{
                let selectedEnvironments = environments.filter{$0.value}
                guard 1 == selectedEnvironments.count else { return .UNKNOWN }
                return Environment.environment(for: selectedEnvironments.first!.key)
            }
     
        }
        return .UNKNOWN
    }
    
    private static func environment(for envString: String)-> Environment{
        
        switch envString.lowercased() {
        case "development", "dev":
            return .DEVELOPMENT
        default:
            return .UNKNOWN
        }
    }
    
    /*
     * @discussion This property returns base url wrt the environment
     */
    private var baseURL: String{
        switch self {
        case .DEVELOPMENT:
            return "https://www.omdbapi.com/"
        case .UNKNOWN:
            fatalError("Please check the environment in plist.")
        }
    }
    
    /*
     * @discussion This property returns api key. This can be configured through plist also.
     */
    private var apiKey: String{
        let key = "?apikey="
        switch self {
        case .DEVELOPMENT:
            return key.appending("eeefc96f")
        case .UNKNOWN:
            fatalError("Please check the environment in plist.")
        }
    }
    
    internal func getBaseURL()->URL{
        
        let baseUrlString = baseURL.appending(apiKey)
        return URL(string: baseUrlString)!
    }
}
