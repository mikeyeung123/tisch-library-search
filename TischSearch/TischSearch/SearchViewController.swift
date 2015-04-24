//
//  SearchViewController.swift
//  TischSearch
//
//  Created by Mike Yeung on 4/22/15.
//  Copyright (c) 2015 Mike Yeung. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var examplesLabel: UILabel!
    let examples = ["“Haruki Murakami”", "“Orwell 1984”", "“Civil War”", "“Unbearable Lightness”", "“IBM”"]
    
    private func animate(var index: Int) {
        UIView.animateWithDuration(2, delay: 0, options: nil, animations: {
            self.examplesLabel.alpha = 0
        }) {fadeOutCompleted in
            if fadeOutCompleted {
                self.examplesLabel.text = self.examples[index]
                index++
                if index == self.examples.count {
                    index = 0
                }
                UIView.animateWithDuration(2, animations: {
                    self.examplesLabel.alpha = 1
                }) {fadeInCompleted in
                    if fadeInCompleted {
                        self.animate(index)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        animate(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
