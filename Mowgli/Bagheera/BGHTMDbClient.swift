//
//  BGHTMDbClient.swift
//  Mowgli
//
//  Created by Cristian Diaz on 06/02/16.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

//MARK: - API URL
let TMDbAPIBaseURL = "https://api.themoviedb.org/3/"

//MARK: - Configuration
//Documentation: http://docs.themoviedb.apiary.io/#configuration
let TMDbConfiguration = "configuration"


public enum MovieListEndpoint: String {
	case Latest = "movie/latest"
	case Upcoming = "movie/upcoming"
	case NowPlaying = "movie/now_playing"
	case Popular = "movie/popular"
	case TopRated = "movie/top_rated"
}

//public enum MovieListError: ErrorType {
//	case NoResponse
//	case NoData
//}


public struct BGHTMDbClient {
	
	public let APIKey: String
	
	public func fetchMovieList(list: MovieListEndpoint) -> MovieList {
		Alamofire.request(.GET, TMDbAPIBaseURL + list.rawValue, parameters: ["api_key": APIKey])
			.responseJSON { response in
				
				guard let JSONData = response.data else {
					return
				}
				
				do {
					let json = try JSON(data: JSONData)
					let movieList = try MovieList(json: json)
					
					return movieList
					print(movieList)
					
				} catch {
					//
				}
		}
	}
	
	public init(APIKey key: String) {
		self.APIKey = key
	}
	
}


public struct MovieList {
	public let results: Array<JSON>
}

extension MovieList: JSONDecodable {
	public init(json value: JSON) throws {
		results = try value.array("results")
	}
}

public struct Movie {
	public let title: String
	public let overview: String
}

extension Movie: JSONDecodable {
	public init(json value: JSON) throws {
		title = try value.string("title")
		overview = try value.string("overview")
	}
}