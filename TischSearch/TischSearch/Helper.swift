//
//  Helper.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/24/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

func dispatchAfter(delay: Double, closure: () -> ()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
                   dispatch_get_main_queue(), closure)
}