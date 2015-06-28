//
//  MoviesViewController.swift
//  mowgli
//
//  Created by Cristian Díaz on 28/06/15.
//  Copyright © 2015 metodowhite. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieCell"

class MoviesViewController: UICollectionViewController {
	
	let notificationCenter = NSNotificationCenter.defaultCenter()
	let presenter = MoviesPresenter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Observe moviesPresenter updates.
		notificationCenter.addObserver(self, selector: "handleMoviesDidUpdateNotification:", name: MoviesPresenterNotifications.PresentedMoviesDidUpdate, object: nil)
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return presenter.moviesSections
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter.numberOfMovies()
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MovieCell {
		let movie = presenter.movieForIndex(indexPath.row)

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCell
		cell.titleLabel.text = movie.name
		cell.yearLabel.text = "\(movie.year)"
		
		if movie.sponsored {
			cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
		}

		return cell
	}
	
	@IBAction func refreshPresentedMovies(sender: UIBarButtonItem) {
		presenter.refreshMovies()
	}
	
	//MARK: -
	
	func handleMoviesDidUpdateNotification(_: NSNotification) {
		self.collectionView?.reloadData()
	}
	
}
