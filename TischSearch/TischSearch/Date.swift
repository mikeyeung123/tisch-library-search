//
//  Date.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/9/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

private let months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]

class Date {
    
    private let year: Int?
    private let month: Int?
    private let day: Int?
    
    init(year: Int?, month: Int?, day: Int?) {
        
        assert(!(year == nil && month != nil) && !(month == nil && day != nil),
               "Nil day can't follow nil month, can't follow nil year")
        
        assert((year == nil || year! <= 2025) &&
               (month == nil || (month! >= 1 && month! <= 12)) &&
               (day == nil || day! >= 1 && day! <= 31) , "Dates out of range")
        
        self.year = year
        self.month = month
        self.day = day
    }
    
    func formattedDate() -> String {
        var date = ""
        if let unwrappedDay = day {
            date += "\(unwrappedDay) "
        }
        if let unwrappedMonth = month {
            date += "\(months[unwrappedMonth - 1]) "
        }
        if let unwrappedYear = year {
            date += "\(unwrappedYear)"
        }
        return date
    }
}