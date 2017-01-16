//
//  ProfileViewController.swift
//  switter
//
//  Created by Mayank Daswani on 1/15/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var profilepic: UIImageView!

    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        dataBaseRef.child("users").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
            
        if let value = snapshot.value as? [String: AnyObject] {
            
            let name = value["username"] as! String
            print(name)
            self.usernameLabel.text = name
            
            let count = value["country"] as! String
            print(count)
            self.userCountryLabel.text = count
            
            let emailid = value["email"] as! String
            print(emailid)
            self.userEmailLabel.text = emailid

            let imageURL = value["photoURL"] as! String
            
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if error == nil
                {
                    if let data = data
                    {
                        DispatchQueue.main.async(execute: {
                            
                            self.profilepic.image = UIImage(data: data)
                        })
                    }
                    
                }
                else
                {
                    let alertView = SCLAlertView()
                    alertView.showError("😁OOPS😁", subTitle: error!.localizedDescription)
                }
            })
            
        }
    })
    
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        if FIRAuth.auth()!.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                
                let alertView = SCLAlertView()
                alertView.showError("😁OOPS😁", subTitle: error.localizedDescription)
            }
        }
        
        
    }
}
