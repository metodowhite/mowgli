//
//  MovieListPresenter.swift
//  Mowgli
//
//  Created by Cristian Diaz on 06/02/16.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import Foundation
import Bagheera
import RxSwift

public struct MovieListPresenter  {
	
	private let disposeBag = DisposeBag()
	
	public let movies: Observable<[Movie]>
	
	public init(list: MovieListEndpoint) {
		movies = BGHTMDbClient(APIKey: "4552c3fa51f05ffc09b73912931a5406")
			.fetchMovies(list)
			.flatMap { (movieList) -> Observable<[Movie]> in
				return movieList.results.toObservable().toArray()
			}
			.observeOn(MainScheduler.instance)
			.shareReplay(1)
	}
}