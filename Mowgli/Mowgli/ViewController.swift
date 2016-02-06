//
//  ViewController.swift
//  Mowgli
//
//  Created by Cristian Diaz on 06/02/16.
//  Copyright © 2016 metodowhite. All rights reserved.
//

import UIKit
import Bagheera

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let testBagheera = BGHTMDbClient(APIKey: "4552c3fa51f05ffc09b73912931a5406")
        testBagheera.fetchMovieList(.NowPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

