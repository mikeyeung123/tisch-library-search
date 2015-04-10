//
//  Author.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/9/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

class Author {
    
    private let firstName: String?
    private let lastName: String?
    
    init(var name: String) {
        var words = name.componentsSeparatedByString(" ")
        if words.count > 0 {
            lastName = words.removeLast()
        } else {
            lastName = nil
        }
        if words.count > 0 {
            firstName = name.substringToIndex(advance(name.endIndex, -count(lastName!) - 1))
        } else {
            firstName = nil
        }
    }
    
    func normalName() -> String {
        var name = ""
        if let first = firstName {
            name += "\(first) "
        }
        if let last = lastName {
            name += last
        }
        return name
    }
    
    func invertedName() -> String {
        var name = ""
        if let last = lastName {
            name += last
        }
        if let first = firstName {
            name += ", \(first)"
        }
        return name
    }
}