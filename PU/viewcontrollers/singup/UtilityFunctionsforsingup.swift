//
//  UtilityFunctionsforsingup.swift
//  PU
//
//  Created by DHRUV on 01/04/24.
//

import UIKit

class UtilityFunctionsforsingup: NSObject{
    
    func showSimpleAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func ShowmovingAlert(vc: UIViewController, title: String, message: String, handler: @escaping(_ action:UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .default) { action in handler(action)
        }
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
