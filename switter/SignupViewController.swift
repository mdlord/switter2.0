//
//  SignupViewController.swift
//  switter
//
//  Created by Mayank Daswani on 1/12/17.
//  Copyright © 2017 Mayank Daswani. All rights reserved.
//

import UIKit
//import Switter

class SignupViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var imagedisp: UIImageView!
    
    var authservice = AuthenticationService()
    
    var pickerView: UIPickerView!
    var countryArrays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserNameTextField.delegate = self
        emailTextField.delegate = self
        PasswordTextField.delegate = self
        rePasswordTextField.delegate = self
        emailTextField.delegate = self
        countryTextField.delegate = self
        

        // Retrieving all the countries, Sorting and Storing them inside countryArrays
        for code in NSLocale.isoCountryCodes as [String]{
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_EN").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            
            countryArrays.append(name)
            print(name)
            countryArrays.sort(by: { (name1, name2) -> Bool in
                name1 < name2
            })
        }
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        //pickerView.dataSource = self.countryArrays
        pickerView.backgroundColor = UIColor.black
        countryTextField.inputView = pickerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Choosing User Picture
    @IBAction func choosePictureAction(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagedisp.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        dismiss(animated: true, completion:nil)
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UserNameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        rePasswordTextField.resignFirstResponder()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        animateView(up: true, moveValue: 80)
    }
    
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(textField: UITextField) {
        animateView(up: false, moveValue: 80)
    }
    
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
        
    }
    
    // MARK: - Picker view data source
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArrays[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countryArrays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArrays.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArrays[row], attributes: [NSForegroundColorAttributeName: UIColor.white])
        return title
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func signUpAction(sender: AnyObject) {
        
        let imgdata = UIImageJPEGRepresentation(imagedisp.image!, 0.8)
        //let email = emailTextField.text!.lowercaseString
        let emailn = emailTextField.text
        let usern = UserNameTextField.text
        let passw = PasswordTextField.text
        let repassw = rePasswordTextField.text
        let countryn = countryTextField.text
        let name = NameTextField.text
        
        if (emailn?.isEmpty)! || (usern?.isEmpty)! || (passw?.isEmpty)! || (repassw?.isEmpty)! || (countryn?.isEmpty)! || (name?.isEmpty)!
            
        {
            self.view.endEditing(true)
            
            let alertView = SCLAlertView()
            alertView.showError("😁OOPS😁", subTitle: "it seems like one of the Fields is empty. Please fill all the Fields and Try Again later.")
            
        }

        else
        {
            if passw != repassw
            {
                print(passw)
                print(repassw)
                let alertview = SCLAlertView()
                alertview.showError("Password Error", subTitle: "The passwords must match")
            }
            else
            {
                //self.view.endEditing(true)
                print (imgdata)
                authservice.signUp(email: emailn!, username: usern!, password: passw!, country: countryn!, data: imgdata as NSData!, firstname: name!)
       
 //           }
        }
        
    }
    

    
}
}
