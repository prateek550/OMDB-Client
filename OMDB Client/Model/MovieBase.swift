//
//  MovieBase.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

struct MovieBase : Codable {
	let movies : [Movie]?
	let totalResults : String?
	let response : String?

	enum CodingKeys: String, CodingKey {

		case movies = "Search"
		case totalResults = "totalResults"
		case response = "Response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		movies = try values.decodeIfPresent([Movie].self, forKey: .movies)
		totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
		response = try values.decodeIfPresent(String.self, forKey: .response)
	}

}
