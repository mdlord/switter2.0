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
        self.tweetTextView.layer.borderWidth = 0.25
      
        self.tweetTextView.delegate = self
        self.updatechar()
    }
    
    @IBAction func withPicButton(_ sender: Any) {
    }

    func updatechar() {
        print(self.tweetTextView.text.characters.count)
        self.charCount.text = "\((140) - self.tweetTextView.text.characters.count)"
    }
//    
//    func textView(textView: UITextView, shouldChangeTextinRange range: NSRange, replacementText text: String)-> Bool
//    {
//        
//        let newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
//        let remainingchar: Int = 140 - newLength
//        print(remainingchar)
//        self.charCount.text = String(remainingchar)
//        
//        return true
//       // return (newLength > 140) ? false : true
//    }
}

