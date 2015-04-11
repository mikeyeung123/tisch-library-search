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
        scraper.mainVC = self
        parser.search("Hong Kong") {book in
            if book != nil {
                scraper.search(book!) {book in
                
                }
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

