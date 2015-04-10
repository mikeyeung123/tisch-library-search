//
//  GoogleBooksAPIParser.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/8/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

class GoogleBooksAPIParser {
    
    // E.g. "2014-08-30"
    private func dateFromString(string: String) -> (year: Int?, month: Int?, day: Int?) {
        var year: Int? = nil
        var month: Int? = nil
        var day: Int? = nil
        let components = string.componentsSeparatedByString("-")
        if components.count >= 1 {
            year = components[0].toInt()!
        }
        if components.count >= 2 {
            month = components[1].toInt()!
        }
        if components.count == 3 {
            day = components[2].toInt()!
        }
        return (year, month, day)
    }
    
    func search(var query: String, completion: ([Book]? -> Void)) {
        
        query = query.stringByReplacingOccurrencesOfString(" ", withString: "%20",
                                                           options: .LiteralSearch, range: nil)
        
        request(.GET, "https://www.googleapis.com/books/v1/volumes",
                parameters: ["q": query, "maxResults": 40])
            .responseJSON {(request, response, JSONIn, error) in
            
            if error != nil {
                
                NSLog("Google Books JSON error: \(error)")
                println(request)
                println(response)
                completion(nil)
                
            } else {
                
                let json = JSON(JSONIn!)
                var books = [Book]()
                assert(json["kind"] == "books#volumes", "Google Books JSON error")
                
                for (key, item) in json["items"] {
                    
                    let title = item["volumeInfo"]["title"].rawString()!
                    let authors = map(item["volumeInfo"]["authors"]) {$1.rawString()!}
                    let publisher = item["volumeInfo"]["publisher"].rawString()
                    
                    var year: Int? = nil
                    var month: Int? = nil
                    var day: Int? = nil
                    if let date = item["volumeInfo"]["publishedDate"].rawString() {
                        (year, month, day) = self.dateFromString(date)
                    }
                    
                    // Remove edition sentence from description
                    var description = item["volumeInfo"]["description"].rawString()
                    if let unwrappedDescription = description {
                        var components = unwrappedDescription.componentsSeparatedByString(". ")
                        if components.last!.lowercaseString.rangeOfString("edition") != nil {
                            components.removeLast()
                            description = " ".join(components) + "."
                        }
                    }
                    
                    let categories = map(item["volumeInfo"]["categories"]) {$1.rawString()!}
                    let image = item["volumeInfo"]["imageLinks"]["smallThumbnail"].rawString()
                    let language =
                        languageFromAbbreviation(item["volumeInfo"]["language"].rawString()!)
                    
                    books.append(Book(title: title, authors: authors, publisher: publisher,
                                      publicationYear: year, publicationMonth: month,
                                      publicationDay: day, description: description,
                                      categories: categories, imageURL: image,
                                      language: language))
                }
                
                completion(books)
            }
        }
    }
}