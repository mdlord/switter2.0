//
//  tweet.swift
//  switter
//
//  Created by Mayank Daswani on 1/16/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct tweet{
    
    var ref: FIRDatabaseReference!
    var key: String!
    var username: String!
    var firstname: String
    var tweetid: String!
    var tweettext: String!
    var tweetimageURL: String!
    var userimageURL: String!
    var withimg: Bool!
    
    
    init(username: String, withimg: Bool, tweetid: String, tweettext: String, tweetimageURL:String, userimageURL: String, firstname: String, key:String = "" )
    {
        self.username = username
        self.firstname = firstname
        self.tweetid = tweetid
        self.tweettext = tweettext
        self.tweetimageURL = tweetimageURL
        self.userimageURL = userimageURL
        self.withimg = withimg
    }
    init(snapshot: FIRDataSnapshot)
    {
         let value = snapshot.value as!
            [String: AnyObject]

            self.firstname = value["firstName"] as! String
            self.username = value["username"] as! String
            self.tweetid = value["tweetid"] as! String
            self.tweetimageURL = value["tweetimageURL"] as! String
            self.tweettext = value["tweettext"] as! String
            self.userimageURL = value["userimageURL"] as! String
            self.withimg = value["withimg"] as! Bool
            self.ref = snapshot.ref
            self.key = snapshot.key
        
    }
    
    func toanyObject()->[String: AnyObject]
    {
        return ["firstname":firstname as AnyObject, "username": username as AnyObject, "tweetid": tweetid as AnyObject, "tweetimageURL":tweetimageURL as AnyObject, "tweettext":tweettext as AnyObject, "userimageURL":userimageURL as AnyObject, "withimg":withimg as AnyObject]
    }
    
    
    

}
