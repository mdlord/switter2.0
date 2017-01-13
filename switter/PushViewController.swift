//
//  ViewController.swift
//  switter
//
//  Created by Mayank Daswani on 1/9/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import UIKit

class PushViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = UIImageView(image: UIImage(named: "twe"))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

