//
//  User.swift
//  switter
//
//  Created by Mayank Daswani on 1/18/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


struct user {

    var username: String!
    var firstname: String
    var country: String!
    var photoURL: String!
    var uid: String!
    var ref: FIRDatabaseReference!
    

    init(snapshot: FIRDataSnapshot)
    {
        let value = snapshot.value as? [String: AnyObject]
        
        self.firstname = value?["firstName"] as! String
        self.username = value?["userName"] as! String
        self.photoURL = value?["tweetimageURL"] as! String
        self.photoURL = value?["photoURL"] as! String
        self.uid = value?["uid"] as! String
        
    }
    
    init(username: String, photoURL: String, UserId: String)
    {
        self.username = username
        self.uid = UserId
        self.photoURL = photoURL
        
    }
    

}
