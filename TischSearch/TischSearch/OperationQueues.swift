//
//  OperationQueues.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/12/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import Foundation

private let singleton = NSOperationQueue()

extension NSOperationQueue {
    func sharedInstance() -> NSOperationQueue {
        return singleton
    }
}