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
import SwiftTask

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

public enum MovieListError: ErrorType {
    case NoResponse
    case NoData
}


public struct BGHTMDbClient {
    
    public let APIKey: String
    
    public func fetchMovieList(list: MovieListEndpoint) {
        task_movieList(list)
            .success { value -> Void in
                print(value)
            }
            .failure { (error: MovieListError?, isCancelled: Bool) -> Void in
                print(error)
        }
    }
    
    public init(APIKey key: String) {
        self.APIKey = key
    }
}

extension BGHTMDbClient {
    
    typealias MovieListTask = Task<Float, MovieList, MovieListError>
    
    func task_movieList(list: MovieListEndpoint) -> MovieListTask {
        return MovieListTask { progress, fulfill, reject, configure in
            Alamofire.request(.GET, TMDbAPIBaseURL + list.rawValue, parameters: ["api_key": self.APIKey])
                .responseJSON { response in
                    
                    guard let JSONData = response.data else {
                        return
                    }
                    
                    do {
                        let json = try JSON(data: JSONData)
                        let movieList = try MovieList(json: json)
                        fulfill(movieList)
                    } catch {
                        reject(MovieListError.NoResponse)
                        return
                    }
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