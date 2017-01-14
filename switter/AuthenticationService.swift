//
//  AuthenticationService.swift
//  switter
//
//  Created by Mayank Daswani on 1/13/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct AuthenticationService {
    
    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        
        return FIRStorage.storage().reference()
    }
    
    // 3 - We save the user info in the Database
    private func saveInfo(user: FIRUser!, username: String, password: String, country: String){
        
        let userInfo = ["email": user.email!, "username": username, "country": country, "uid": user.uid, "photoURL": String(describing: user.photoURL!)]
        
        let userRef = databaseRef.child("users").child(user.uid)
        
        userRef.setValue(userInfo)
        
        signIn(email: user.email!, password: password)
        
        
    }
    
    // 4 - We sign in the User
    func signIn(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
                if let user = user {
                    
                    print("\(user.displayName!) has signed in successfuly")
                    
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                }
                
            }else {
                
                let alertView =  SCLAlertView()
                alertView.showError("😁OOPS😁", subTitle: error!.localizedDescription)
                
            }
        })
        
    }
    
    // 1 - We create firstly a New User
    func signUp(email: String, username: String, password: String, country: String, data: NSData!){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
                self.setUserInfo(user: user, username: username, password: password, country: country, data: data)
                
                
            }else {
                
                let alertView =  SCLAlertView()
                alertView.showError("😁OOPS😁", subTitle: error!.localizedDescription)
            }
        })
        
    }
    
    
    // 2 - We set the User Info
    private func setUserInfo(user: FIRUser!, username: String, password: String, country: String, data: NSData!){
        
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        let imageRef = storageRef.child(imagePath)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.put(data as Data, metadata: metadata) { (metadata, error) in
            if error == nil {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                
                if let photoURL = metadata!.downloadURL(){
                    changeRequest.photoURL = photoURL
                }
                
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        
                        self.saveInfo(user: user, username: username, password: password, country: country)
                    }
                    else {
                        
                        let alertView =  SCLAlertView()
                        alertView.showError("😁OOPS😁", subTitle: error!.localizedDescription)
                        
                    }
                    
                })
            }else {
                
                let alertView =  SCLAlertView()
                alertView.showError("😁OOPS😁", subTitle: error!.localizedDescription)
                
            }
        }
        
        
    }
    
}
