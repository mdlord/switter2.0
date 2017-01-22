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

class AddNewPostViewController: UIViewController , UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var databaseRef: FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage{
        return FIRStorage.storage()
    }
    
    var currentUser: user! 
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var tweetimage: UIImageView!
    var imgselected = false
    
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
    
    func viewWillAppear(){
        super.viewWillAppear(true)
        
        let userRef = FIRDatabase.database().reference().child("users").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()!.currentUser!.uid)
        
        userRef.observe(.value, with: {(snapshot) in
            for userInfo in snapshot.children{
                self.currentUser = user(snapshot: userInfo as! FIRDataSnapshot)
            }
        })

    }
    
    @IBAction func withPicButton(_ sender: Any) {
        
        imgselected = true
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        _ = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
//        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)

        
    }
    
    @IBAction func pushpostbutton(_ sender: Any) {
        
        var tweetText : String!
        if let text: String = tweetTextView.text{
            tweetText = text
        }
        else{
            tweetText = ""
        }
        
        if imgselected == true{
            let imgData = UIImageJPEGRepresentation(tweetimage.image!, 0.8)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            let imagepath = "tweetimage\(FIRAuth.auth()!.currentUser!.uid)/tweetpic.jpg"
        
            let imageref = storageRef.reference().child(imagepath)
            
            imageref.put(imgData!, metadata: metadata, completion: {(newMetaData, error) in
                if error == nil{
                    
                    let newTweet = tweet(username: self.currentUser.username, withimg: true, tweetid: NSUUID().uuidString, tweettext: tweetText, tweetimageURL: String(describing: newMetaData?.downloadURL()!), userimageURL: self.currentUser.photoURL, firstname: self.currentUser.firstname)
                    
                    let tweetRef = self.databaseRef.child("tweet").childByAutoId()
                    tweetRef.setValue(newTweet.toanyObject(), withCompletionBlock: {(error,ref) in
                    
                        if error==nil{
                            self.navigationController?.popToRootViewController(animated: true)
                        }

                    })
                    
                    
                }else{
                    print(error!.localizedDescription)
                }
            })
        }
        else{
            
            let newTweet = tweet(username: self.currentUser.username, withimg: false, tweetid: NSUUID().uuidString, tweettext: tweetText, tweetimageURL: "", userimageURL: self.currentUser.photoURL, firstname: self.currentUser.firstname)
            
            let tweetRef = self.databaseRef.child("tweet").childByAutoId()
            tweetRef.setValue(newTweet.toanyObject(), withCompletionBlock: {(error,ref) in
                
                if error==nil{
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            })
        
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        tweetimage.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        dismiss(animated: true, completion:nil)
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingchar: Int = 140 - newLength
        //print(remainingchar)
        self.charCount.text = String(remainingchar)
        
        if remainingchar < 0{
            self.charCount.text = "0 "
            charCount.textColor = UIColor.red
        }
        else{
            charCount.textColor = UIColor.black
        }
        
        return true
    }

}

