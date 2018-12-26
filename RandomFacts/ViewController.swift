//
//  ViewController.swift
//  RandomFacts
//
//  Created by Michael Vytlingam on 2018-12-08.
//  Copyright © 2018 Michael Vytlingam. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
let buttonHeight = 50.0
var currentArticle = Article()
    override func viewDidLoad() {
        super.viewDidLoad()
        randomButton.layer.cornerRadius = CGFloat(buttonHeight / 2.0)
        randomButton.layer.borderWidth = 3
        randomButton.layer.borderColor = UIColor.white.cgColor
        openButton.layer.cornerRadius = CGFloat(buttonHeight / 2.0)
        openButton.layer.borderWidth = 3
        openButton.layer.borderColor = UIColor.white.cgColor
        background.backgroundColor = getRandomBackground()
    }
    @IBOutlet var background: UIView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    
    @IBAction func randomize(_ sender: UIButton) {
        background.backgroundColor = getRandomBackground()
        let article = Article()
        article.createArticle {
            success in
            self.currentArticle = article
        }
        
    }
    
    
    @IBAction func openPage(_ sender: UIButton) {
        guard let url = URL(string: self.currentArticle.getLink()) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    func getRandomBackground() -> UIColor {
        let r = CGFloat(Float.random(in: 0.0...1.0))
        let g = CGFloat(Float.random(in: 0.0...1.0))
        let b = CGFloat(Float.random(in: 0.0...1.0))
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

