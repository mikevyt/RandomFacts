//
//  Fetcher.swift
//  RandomFacts
//
//  Created by Michael Vytlingam on 2018-12-08.
//  Copyright © 2018 Michael Vytlingam. All rights reserved.
//

import Foundation

class Fetcher {
    var id: Int = 0
    struct Response: Codable {
        struct Query: Codable {
            let random: [Random]
        }
        
        struct Random: Codable {
            let id, ns: Int
            let title: String
        }
        
        struct Continue: Codable {
            let rncontinue, continueContinue: String
            
            enum CodingKeys: String, CodingKey {
                case rncontinue
                case continueContinue = "continue"
            }
        }
        
        let batchcomplete: String
        let `continue`: Continue
        let query: Query
        
        enum CodingKeys: String, CodingKey {
            case batchcomplete, `continue`, query
        }
    }
    func getArticleID(url: URL, completion: @escaping (Int?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            guard err == nil else { print(err!); return }
        
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                if let firstArticle = response.query.random.first {
                    self.id = firstArticle.id
                } else {
                    print(err!)
                }
            } catch {
                print(err!)
            }
        }.resume()
    }
    func getRandomArticle() {
        let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=1&format=json")
        getArticleID(url: url!) { (articleID, err) in
            if err == nil {
                self.id = articleID!
            }
        }
    }
}
