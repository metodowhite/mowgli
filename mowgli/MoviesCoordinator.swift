//
//  MoviesCoordinator.swift
//  mowgli
//
//  Created by Cristian Díaz on 28/06/15.
//  Copyright © 2015 metodowhite. All rights reserved.
//

import Foundation


protocol MoviesCoordinatorDelegate {
	func coordinatorDidUpdate(movies: [Movie])
}

class MoviesCoordinator {
	var moviesAll = 10
	var delegate: MoviesCoordinatorDelegate?
	
	let moviesSections = 1
	let moviesSponsored = [Movie(name: "jUan", year: 1979, sponsored: true), Movie(name: "blua", year: 2015, sponsored: true), Movie(name: "power", year: 1999, sponsored: true)]
	
	
	func refreshMovies() {
		self.delegate?.coordinatorDidUpdate( [Movie(name: "test", year: 1992, sponsored: false), Movie(name: "Bla", year: 2012, sponsored: false)] )
	}
	
	/*
	func queryMovies() {
	let moviesQuery = Movie.query()!
	moviesQuery.whereKey("title", equalTo:"bla")
	
	moviesQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
	if error == nil {
	println("Successfully retrieved \(objects!.count) movies.")
	
	if let movies = objects as? [Movie] {
	self.delegate?.coordinatorDidUpdate(movies: movies)
	}
	} else {
	println("Error: \(error!) \(error!.userInfo!)")
	}
	}
	}*/
}