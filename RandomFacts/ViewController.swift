//
//  ViewController.swift
//  RandomFacts
//
//  Created by Michael Vytlingam on 2018-12-08.
//  Copyright © 2018 Michael Vytlingam. All rights reserved.
//

import UIKit
import SafariServices
import QuartzCore

class ViewController: UIViewController {
    private let buttonHeight = 50.0
    private var currentArticle = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.backgroundColor = getRandomBackground()
        setupButtons()
        setupLabels()
        getNewArticle()
    }
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var background: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    
    @IBAction func randomize(_ sender: UIButton) {
        background.backgroundColor = getRandomBackground()
        getNewArticle()
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
    
    func setupButtons() {
        for button in buttons {
            button.layer.cornerRadius = CGFloat(buttonHeight / 2.0)
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func setupLabels() {
        descriptionText.layer.cornerRadius = CGFloat(buttonHeight / 2.0)
        descriptionText.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        titleText.layer.cornerRadius = CGFloat(buttonHeight / 2.0)
        titleText.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func updateScreen() {
        self.titleText.text = self.currentArticle.title
        self.descriptionText.text = self.currentArticle.description
    }
    
    func getNewArticle() {
        let article = Article()
        article.createArticle {
            success in
            self.currentArticle = article
            if (self.currentArticle.description.range(of:"may refer") != nil || self.currentArticle.description.range(of:"can refer") != nil || self.currentArticle.description == "") {
                print("getting new article")
                self.getNewArticle()
            }
            DispatchQueue.main.async {
                self.updateScreen()
            }
        }
    }
}

