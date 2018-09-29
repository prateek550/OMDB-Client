//
//  NetworkHelper.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestParams = [URLQueryItem]
typealias ServiceResponse = (data: Data?, error: Error?)

struct NetworkHelper{
    
    /*
     * @discussion This method constructs url based on environment
     * @param actionURL: endpointURL
     * @param requestParams: endpointURL specific request parameters
     */
    private static func constructURL(requestParams: RequestParams)-> URL?{
    
        var url = URLComponents(url: Environment.getDefaultEnvironment().getBaseURL(), resolvingAgainstBaseURL: false)
        for param in requestParams{
            url?.queryItems?.append(param)
        }
        return try! url?.asURL()
    }
    
    /*
     * @discussion this method makes a GET request to retrieve data
     * @param actionURL: request url
     * @param response: response data
     */
    static func fetchRequest(requestParams: RequestParams, response: @escaping (ServiceResponse)->Void){
        
        guard let url = constructURL(requestParams: requestParams) else {return}
        Alamofire.request(url)
        .validate()
        .responseData { (responseData) in
                response(validateServerResponse(dataResponse: responseData))
        }
    }
    
    /*!
     * @discussion This method validates server response.
     * @param defaultDataResponse: response from service call
     * @return ServerResponse: serverResponse can be failure/success.
     */
    private static func validateServerResponse(dataResponse: DataResponse<Data>)->ServiceResponse{
        
        // Checking for Http response error
        if nil == dataResponse.error, 200 == dataResponse.response?.statusCode, let data = dataResponse.data{
//             Checking server error
            if let serverError = try? JSONDecoder().decode(Error.self, from: data){
                return (nil, serverError)
            }
            else{
//             Server returned non error response. Assuming its SUCCESS.
                return (data,nil)
            }
        }
        else{
            // Return http error response
            let error = Error(response: String(describing:dataResponse.response?.statusCode ?? 0), error: dataResponse.error?.localizedDescription ?? "")
            return (nil, error)
        }
    }
}
