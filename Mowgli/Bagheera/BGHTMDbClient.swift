//
//  BGHTMDbClient.swift
//  Mowgli
//
//  Created by Cristian Diaz on 06/02/16.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - API URL
let TMDbAPIBaseURL = "https://api.themoviedb.org/3/"

//MARK: - Configuration
//Documentation: http://docs.themoviedb.apiary.io/#configuration
let TMDbConfiguration = "configuration"


public enum MovieList: String {
    case Latest = "movie/latest"
    case Upcoming = "movie/upcoming"
    case NowPlaying = "movie/now_playing"
    case Popular = "movie/popular"
    case TopRated = "movie/top_rated"}

public struct BGHTMDbClient {
    
    public let APIKey: String
    
    public func fetchMovieList(list: MovieList) {
        Alamofire.request(.GET, TMDbAPIBaseURL + list.rawValue, parameters: ["api_key": APIKey])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    public init(APIKey key: String) {
        self.APIKey = key
    }
    
}


struct Movie {
    //
}