//
//  Book.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/9/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
    let title: String
    let authors: [Author]
    var publisher: String?
    var publicationDate: Date
    var description: String?
    var categories: [String]
    let image: UIImage?
    let language: String?
    
    init(title: String, authors: [String], publisher: String?, publicationYear: Int?, publicationMonth: Int?,
         publicationDay: Int?, description: String?, categories: [String]?, imageURL: String?, language: String?) {
        
        self.title = title
        self.authors = authors.map {Author(name: $0)}
        self.publisher = publisher
        
        publicationDate = Date(year: publicationYear, month: publicationMonth, day: publicationDay)
        
        self.description = description
        
        if let unwrappedCategories = categories {
            self.categories = unwrappedCategories
        } else {
            self.categories = [String]()
        }
        
        if let unwrappedImageURL = imageURL, unwrappedNSURL = NSURL(string: unwrappedImageURL),
            data = NSData(contentsOfURL: unwrappedNSURL), unwrappedImage = UIImage(data: data) {
            image = unwrappedImage
        } else {
            image = nil
        }
        
        self.language = language
    }
    
    // Testing only
    func print() {
        println("“\(title)” by \(authors.map {$0.normalName()}) published by \(publisher) on \(publicationDate.formattedDate()) in \(categories) in \(language)")
        println(description)
        println()
    }
}