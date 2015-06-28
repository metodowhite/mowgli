//
//  MoviesPresenter.swift
//  mowgli
//
//  Created by Cristian Díaz on 28/06/15.
//  Copyright © 2015 metodowhite. All rights reserved.
//

import Foundation


struct MoviesPresenterNotifications {
	static let PresentedMoviesDidUpdate = "PresentedMoviesDidUpdate"
}


class MoviesPresenter: MoviesCoordinatorDelegate {

	private let coordinator = MoviesCoordinator()
	private let notificationCenter = NSNotificationCenter.defaultCenter()

	private(set) var moviesAll = [Movie]() {
		didSet {
			notificationCenter.postNotificationName(MoviesPresenterNotifications.PresentedMoviesDidUpdate, object: self)
		}
	}
	
	let moviesSections = 1
	var moviesSponsored: [Movie] {
		return coordinator.moviesSponsored
	}
	
	//MARK: - Methods
	
	init() {
		coordinator.delegate = self
	}
	
	func coordinatorDidUpdate(movies: [Movie]) {
		moviesAll = movies + moviesSponsored
	}
	
	func refreshMovies() {
		coordinator.refreshMovies()
	}
	
	func movieForIndex(index: Int) -> Movie {
		return moviesAll[index]
	}
	
	func numberOfMovies() -> Int {
		return moviesAll.count
	}
}

