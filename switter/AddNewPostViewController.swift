//
//  AddNewPostViewController.swift
//  switter
//
//  Created by Mayank Daswani on 1/17/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddNewPostViewController: UIViewController , UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = true
        self.tweetTextView.layer.cornerRadius = 5
        self.tweetTextView.layer.borderWidth = 0.15
      
        tweetTextView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func withPicButton(_ sender: Any) {
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingchar: Int = 140 - newLength
        print(remainingchar)
        self.charCount.text = String(remainingchar)
        
        return true
    }

}

