//
//  AppDelegate.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/8/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        // TESTING
        
        
        
        let colorless = Book(title: "Colorless Tsukuru Tazaki and His Years of Pilgrimage", authors: ["Haruki Murakami"], publisher: "Random House", publicationYear: 2014, publicationMonth: 8, publicationDay: 12, description: "A mesmerising mystery story about friendship from the internationally bestselling author of Norwegian Wood and 1Q84 Tsukuru Tazaki had four best friends at school. By chance all of their names contained a colour. The two boys were called Akamatsu, meaning ‘red pine’, and Oumi, ‘blue sea’, while the girls’ names were Shirane, ‘white root’, and Kurono, ‘black field’. Tazaki was the only last name with no colour in it. One day Tsukuru Tazaki’s friends announced that they didn't want to see him, or talk to him, ever again. Since that day Tsukuru has been floating through life, unable to form intimate connections with anyone. But then he meets Sara, who tells him that the time has come to find out what happened all those years ago.", categories: ["Fiction"], imageURL: "http://books.google.com/books/content?id=zrlZAwAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api", language: "English")
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

