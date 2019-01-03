//
//  Article.swift
//  RandomFacts
//
//  Created by Michael Vytlingam on 2018-12-24.
//  Copyright © 2018 Michael Vytlingam. All rights reserved.
//

import Foundation

class Article {
    var pageID: Int = 0
    var title: String = ""
    var description: String = ""
    
    private let regexHTML = "<[^>]*>"
    private let regexFirstSentence = "(^.{10,}?[a-z0-9]{2,}[.!?])\\s+\\W*[A-Z]"
    
    struct Response: Decodable {
        struct Query: Decodable {
            let pages: Pages
        }
        struct Pages: Decodable {
            var randomID: RandomID?
            struct RandomID: Decodable {
                let pageid: Int
                let title: String
                let extract: String
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                for key in container.allKeys {
                    randomID = try? container.decode(RandomID.self, forKey: key)
                }
            }
            struct CodingKeys: CodingKey {
                var stringValue: String
                init?(stringValue: String) {
                    self.stringValue = stringValue
                }
                var intValue: Int?
                init?(intValue: Int) {
                    return nil
                }
            }
        }
        let query: Query
        enum CodingKeys: String, CodingKey {
            case query
        }
    }
    
    func createArticle(completionHandler: @escaping (Bool) -> Void) {
        getArticle() {
            (pageID, title, description, err) in
            if err != nil {
                completionHandler(false)
            }
            self.pageID = pageID
            self.title = title
            self.description = self.parseText(text: description)
            completionHandler(true)
        }
    }
    
    func getArticle(completionHandler: @escaping (Int, String, String, Error?) -> Void) {
        guard let apiUrl = URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&generator=random&grnnamespace=0&prop=revisions&rvprop=content&grnlimit=1&rvsection=0&prop=extracts") else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl) { (data, response, err) in
            guard let data = data else { return }
            guard err == nil else { print(err!); return }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completionHandler(response.query.pages.randomID!.pageid, response.query.pages.randomID!.title, response.query.pages.randomID!.extract, nil)
            } catch {
                print("err!")
            }
        }.resume()
    }
    
    func parseText(text: String) -> String {
        let noHTML = text.replacingOccurrences(of: self.regexHTML, with: "", options: .regularExpression).trimmingCharacters(in: .whitespacesAndNewlines)
        var firstSentence = matches(for: regexFirstSentence, in: noHTML)
        if (firstSentence.count == 0) {
            return ""
        }
        let str = firstSentence[0]
        let index = str.index(str.endIndex, offsetBy: -2)
        return String(str[..<index])
    }
    
    func getLink() -> String {
        return "https://en.wikipedia.org/?curid=\(self.pageID)"
    }

    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
