//
//  GoogleBooksAPIParser.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/8/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

class GoogleBooksAPIParser {
    
    // Must be <= 40
    private let maxResults = 40
    
    init() {
        assert(maxResults <= 40, "Max results must be <= 40 for Google Books API")
    }
    
    // E.g. "2014-08-30"
    private func dateFromString(string: String) -> (year: Int?, month: Int?, day: Int?) {
        var year: Int? = nil
        var month: Int? = nil
        var day: Int? = nil
        let components = string.componentsSeparatedByString("-")
        if components.count >= 1 {
            year = components[0].toInt()
        }
        if components.count >= 2 {
            month = components[1].toInt()
        }
        if components.count == 3 {
            day = components[2].toInt()
        }
        return (year, month, day)
    }
    
    func search(var query: String, completionEach: (Book? -> Void)) {
        
        query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        request(.GET,
                "https://www.googleapis.com/books/v1/volumes?q=\(query)&maxResults=\(maxResults)")
            .responseJSON {(request, response, JSONIn, error) in
            
            if error != nil {
                NSLog("Google Books JSON error: \(error)")
                println(request)
                println(response)
                return
            }
                
            let json = JSON(JSONIn!)
            assert(json["kind"] == "books#volumes", "Google Books JSON error")
            
            for (key, item) in json["items"] {
                
                var title = item["volumeInfo"]["title"].rawString()!
                let components = title.componentsSeparatedByString(" - Page")
                if components.count > 1 {
                    title = components[0]
                }
                
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
                
                completionEach(Book(title: title, authors: authors, publisher: publisher,
                    publicationYear: year, publicationMonth: month,
                    publicationDay: day, description: description,
                    categories: categories, imageURL: image,
                    language: language))
            }
        }
    }
}