//
//  ViewController.swift
//  RandomFacts
//
//  Created by Michael Vytlingam on 2018-12-08.
//  Copyright © 2018 Michael Vytlingam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
let fetcher = Fetcher()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.getRandomArticle()
        print(fetcher.id)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func Click(_ sender: UIButton) {
        fetcher.getRandomArticle()
        print(fetcher.id)
    }
    
}

