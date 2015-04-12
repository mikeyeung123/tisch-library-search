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
    
    private func scrapeRecordFromRow(book: Book, row: HTMLNode) {
        let cols = row.findChildTags("td")
        let location = cols[0].findChildTag("a")!.contents
        if location.rangeOfString("Tisch") != nil && location.rangeOfString("Media") == nil {
            let callNumber = cols[1].findChildTag("a")!.contents
            var status = cols[2].rawContents
            let range = status.rangeOfString("(?<=-->\\s).+(?=\\s<\\/td)", options: .RegularExpressionSearch)
            if range != nil {
                status = status.substringWithRange(range!)
            }
            book.records.append((location, callNumber, status))
        }
    }
    
    private func handleNotFound(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        //
    }
    
    private func handleFound(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        if let table = parser.body?.findChildTagAttr("table", attrName: "id", attrValue: "bibItems") {
            for row in table.findChildTagsAttr("tr", attrName: "class", attrValue: "bibItemsEntry") {
                scrapeRecordFromRow(book, row: row)
            }
            // TEST CODE
            mainVC?.textView.text! += "'\(book.title)' by \(book.authors[0].normalName())\n"
            for record in book.records {
                mainVC?.textView.text! += "\(record.location); \(record.callNumber); \(record.status)\n"
            }
            mainVC?.textView.text! += "\n"
            
        } else {
            mainVC?.textView.text! += "Error: '\(book.title)' by \(book.authors[0].normalName())\n\n"
        }
    }
    
    private func handleList(book: Book, parser: HTMLParser, completion: (Book? -> Void)) {
        if let citations = parser.body?.findChildTagsAttr("tr", attrName: "class", attrValue: "briefCitRow") {
            for citation in citations {
                for row in citation.findChildTagsAttr("tr", attrName: "class", attrValue: "bibItemsEntry") {
                    scrapeRecordFromRow(book, row: row)
                }
            }
            // TEST CODE
            mainVC?.textView.text! += "'\(book.title)' by \(book.authors[0].normalName())\n"
            for record in book.records {
                mainVC?.textView.text! += "\(record.location); \(record.callNumber); \(record.status)\n"
            }
            mainVC?.textView.text! += "\n"
        } else {
            mainVC?.textView.text! += "List parsing error: '\(book.title)' by \(book.authors[0].normalName())\n\n"
        }
    }
    
    func search(book: Book, completion: (Book? -> Void)) {
        
        let title = book.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let author =
            book.authors.first?.invertedName().stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
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