//
//  service.swift
//  PU
//
//  Created by DHRUV on 02/04/24.
//

import UIKit
import Firebase
class Service{
    
    static func signUpUser(email: String, password: String, username: String, phonenumber: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onError(error)
                return
            }
            uploadTodatabase(email: email, password: password, username: username, phonenumber: phonenumber, onSuccess: onSuccess)
            
        }
    }
    
    static func uploadTodatabase(email: String, password: String, username: String, phonenumber: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("newusers").child(uid!).setValue(["email": email, "password": password, "username": username , "phonenumber": phonenumber])
        onSuccess()
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }

}
