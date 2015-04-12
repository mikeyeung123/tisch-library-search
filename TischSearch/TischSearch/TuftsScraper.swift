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
        //
    }
    
    private func handleFound(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        if let table = parser.body?.findChildTagAttr("table", attrName: "id", attrValue: "bibItems") {
            for row in table.findChildTagsAttr("tr", attrName: "class", attrValue: "bibItemsEntry") {
                let cols = row.findChildTags("td")
                let location = cols[0].findChildTag("a")!.contents
                if location.rangeOfString("Tisch") != nil {
                    var status = cols[2].rawContents
                    let range = status.rangeOfString("(?<=-->\\s).+(?=\\s<\\/td)", options: .RegularExpressionSearch)
                    if range != nil {
                        status = status.substringWithRange(range!)
                    }
                    mainVC?.textView.text! += "'\(book.title)' by \(book.authors[0].normalName()) in \(location) under " + cols[1].findChildTag("a")!.contents + ": " + status + "\n\n"
                }
            }
        } else {
            mainVC?.textView.text! += "Error: '\(book.title)' by \(book.authors[0].normalName())\n\n"
        }
    }
    
    private func handleList(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        mainVC?.textView.text! += "Multiple found; not implemented: '\(book.title)' by \(book.authors[0].normalName())\n\n"
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
                    if let table = body.findChildTagAttr("table", attrName: "id", attrValue: "browse_screen") {
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
                    } else if let errorMessage = body.findChildTagAttr("div", attrName: "class", attrValue: "msg") {
                        if errorMessage.contents.rangeOfString("therefore not used") != nil {
                            self.handleNotFound(book, parser: parser, completion: completion)
                        } else {
                            self.handleFound(book, parser: parser, completion: completion)
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