//
//  PersonProfileView.swift
//  StumblrMapView
//
//  Created by Venkata Vijay on 6/6/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit

class PersonProfileView: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func onCancelTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
