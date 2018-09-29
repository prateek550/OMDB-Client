//
//  Error.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

struct Error : Codable {
	let response : String?
	let error : String

	enum CodingKeys: String, CodingKey {
		case response = "Response"
		case error = "Error"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		response = try values.decodeIfPresent(String.self, forKey: .response)
		error = try values.decode(String.self, forKey: .error)
	}
    
    init(response: String, error: String){
        self.response = response
        self.error = error
    }

}
