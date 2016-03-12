//
//  BagTMDbClient.swift
//  Mowgli
//
//  Created by Cristian Diaz on 12/03/16.
//  Copyright © 2016 metodowhite. All rights reserved.
//
//	Documentation: http://docs.themoviedb.apiary.io/#configuration
//

import Foundation
import Alamofire
import Freddy

private let TMDbAPIBaseURL = "https://api.themoviedb.org/3/"
private let TMDbConfiguration = "configuration"

public enum MovieListEndpoint: String {
	case Latest = "movie/latest"
	case Upcoming = "movie/upcoming"
	case NowPlaying = "movie/now_playing"
	case Popular = "movie/popular"
	case TopRated = "movie/top_rated"
}

public enum MovieListError: ErrorType {
	case NoResponse
	case NoData
}


public struct BagTMDbClient {
	
	private let APIKey: String

	public init(APIKey key: String) {
		self.APIKey = key
	}
	
	public func fetchMovies(list: MovieListEndpoint) {
		Alamofire.request(.GET, TMDbAPIBaseURL + list.rawValue, parameters: ["api_key": self.APIKey])
			.responseJSON { response in
				
				guard let JSONData = response.data else {
					return
				}
				
				do {
					let json = try JSON(data: JSONData)
					let movieList = try MovieList(json: json)
					//					fulfill(movieList)
				} catch {
					//					reject(MovieListError.NoResponse)
					return
				}
		}
	}
}

public struct MovieList {
	public let page: Int
	public let results: Array<Movie>
	public let totalPages: Int
	public let totalResults: Int
}

extension MovieList: JSONDecodable {
	public init(json value: JSON) throws {
		page = try value.int("page")
		results = try value.arrayOf("results", type: Movie.self)
		totalPages = try value.int("total_pages")
		totalResults = try value.int("total_results")
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