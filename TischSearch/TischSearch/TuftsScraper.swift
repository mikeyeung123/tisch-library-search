//
//  TuftsScraper.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/10/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation
import UIKit

class TuftsScraper {
    
    var mainVC: ViewController?
    
    private func handleNotFound(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        mainVC?.textView.text! += "Not found: '\(book.title)'"
        if book.authors.count > 0 {
            mainVC?.textView.text! += " by \(book.authors[0].normalName())"
        }
        mainVC?.textView.text! += "\n"
    }
    
    private func handleFound(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        mainVC?.textView.text! += "Found: '\(book.title)'"
        if book.authors.count > 0 {
            mainVC?.textView.text! += " by \(book.authors[0].normalName())"
        }
        mainVC?.textView.text! += "\n"
    }
    
    private func handleList(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        mainVC?.textView.text! += "List: '\(book.title)'"
        if book.authors.count > 0 {
            mainVC?.textView.text! += " by \(book.authors[0].normalName())"
        }
        mainVC?.textView.text! += "\n"
    }
    
    func search(book: Book, completion: (Book? -> Void)) {
        
        let title = book.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let author = book.authors.first?.invertedName().stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
            let URL = "http://library.tufts.edu/search/q?author=\(author)&title=\(title)&searchscope=2"
            request(.GET, URL).responseString {(request, response, HTML, error) in
                
                if error != nil {
                    NSLog("Scraper error: \(error)")
                    println(request)
                    println(response)
                    completion(nil)
                    return
                }
                
                var parserError: NSError?
                let parser = HTMLParser(html: HTML!, error: &parserError)
                if parserError != nil {
                    NSLog("Parser error: \(parserError)")
                    completion(nil)
                    return
                }
                
                if let body = parser.body {
                    if let table = body.findChildTagAttr("table", attrName: "id", attrValue: "browse_screen")?.findChildTag("div") {
                        if let errorMessage = table.findChildTagAttr("tr", attrName: "class", attrValue: "msg") {
                            self.handleNotFound(book, parser: parser, completion: completion)
                        } else if let cell = table.findChildTags("tr").first?.findChildTag("td") {
                            if let errorMessage = cell.findChildTagAttr("div", attrName: "class", attrValue: "msg") {
                                self.handleNotFound(book, parser: parser, completion: completion)
                            } else {
                                self.handleList(book, parser: parser, completion: completion)
                            }
                        } else {
                            assertionFailure("Parser error")
                        }
                    } else {
                        self.handleFound(book, parser: parser, completion: completion)
                    }
                } else {
                    NSLog("HTML body not found")
                    completion(nil)
                    return
                }
            }
        } else {
            completion(nil)
        }
    }
}