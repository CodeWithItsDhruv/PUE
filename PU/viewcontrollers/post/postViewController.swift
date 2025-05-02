//
//  postViewController.swift
//  PU
//
//  Created by DHRUV on 30/03/24.
//

import UIKit

class postViewController: UIViewController {
    
    @IBOutlet weak var myimg: UIImageView!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var errorforcreate: UILabel!
    
    var activetextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear the text fields when the view appears
        emailtxt.text = ""
        passtxt.text = ""
        errorforcreate.text = ""
        
        emailtxt.delegate = self
        passtxt.delegate = self
        
        //textfield ne keyboard ni upar lava mate no code
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardshow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let admingif = UIImage.gifImageWithName("admin")
        myimg.image = admingif
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginbtntapped(_ sender: UIButton) {
        let username = emailtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        print("Entered Username: \(username)")
        print("Entered Password: \(password)")
        
        if username.isEmpty || password.isEmpty {
            errorforcreate.isHidden = false
            errorforcreate.text = "Please enter valid details"
        } else {
            // Define valid username-password pairs
            let validCredentials = [
                "tec": "tec",
                "admin": "admin",
                // Add more username-password pairs as needed
            ]
            
            // Check if the entered username-password combination is valid
            if let expectedPassword = validCredentials[username.lowercased()], password == expectedPassword {
                print("Login Successful")
                // Successful login, navigate to the next screen
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "addeventViewController") as? addeventViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                print("Login Failed")
                // Invalid credentials, show error message
                errorforcreate.isHidden = false
                errorforcreate.text = "Invalid username or password"
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardshow(notification:Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardsize.height
        let editingTextFieldY = activetextfield.convert(activetextfield.bounds,to:self.view).minY;
        if self.view.frame.minY >= 0 {
            if editingTextFieldY > keyboardY - 50 {
                UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y-(editingTextFieldY-(keyboardY-120)), width: self.view.bounds.width, height: self.view.bounds.height)
                },completion: nil)
            }
        }
    }
    
    @objc func keyboardHidden(notification:Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        },completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    func clearTextFields() {
        emailtxt.text = ""
        passtxt.text = ""
    }
}

extension postViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activetextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
