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
    var firstname: String!
    var country: String!
    var photoURL: String!
    var uid: String!
    var ref: FIRDatabaseReference!
    var key: String!
    

    init(username: String, country: String, photoURL:String, firstname: String, key:String = "" )
    {
        self.username = username
        self.firstname = firstname
        self.photoURL = photoURL
        self.country = country
      //  self.withimg = withimg
    }
    

    init(snapshot: FIRDataSnapshot)
    {
        let value = snapshot.value as? [String: AnyObject]
        
        self.firstname = value?["firstName"] as! String
        self.username = value?["userName"] as! String
        self.country = value?["country"] as! String
        self.uid = value?["uid"] as! String
        self.photoURL = value?["photoURL"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        
    }
    

    
}
