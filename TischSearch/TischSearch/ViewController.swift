//
//  ViewController.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/8/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        // TESTING
        
        
        textView.text = ""
        
        let parser = GoogleBooksAPIParser()
        let scraper = TuftsScraper()
        parser.search("asian americans") {parserBook in
            if let unwrappedParserBook = parserBook {
                scraper.search(unwrappedParserBook) {scraperBook in
                    if let book = scraperBook {
                        self.textView.text! += "'\(book.title)' by \(book.authors[0].normalName())\n"
                        for record in book.records {
                            self.textView.text! += "\(record.location); \(record.callNumber); \(record.status)\n"
                        }
                        self.textView.text! += "\n"
                    }
                }
            }
        }
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

