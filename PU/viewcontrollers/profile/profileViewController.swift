//
//  profileViewController.swift
//  PU
//
//  Created by DHRUV on 30/03/24.
//

import UIKit
import Firebase

class profileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutbtn(_ sender: Any) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            UserDefaults.standard.set(false, forKey: "isUserSignedIn") // Clear user sign-in flag
            navigateToLogin() // Navigate back to login screen
        }catch let signOutError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func navigateToLogin() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? loginViewController {
            navigationController?.setViewControllers([loginVC], animated: true)
        }
    }
    
    
    @IBAction func share(_ sender: Any) {
        // Text to share
           let text = "Check out this awesome app!"
           
           // URL to share (replace with your app's App Store link)
           guard let appURL = URL(string: "https://example.com/app") else { return }
           
           // Set up activity view controller
           let activityViewController = UIActivityViewController(activityItems: [text, appURL], applicationActivities: nil)
           
           // Exclude some activity types from the list (optional)
           activityViewController.excludedActivityTypes = [
               .airDrop,
               .addToReadingList,
               .assignToContact,
               .markupAsPDF,
               .postToTencentWeibo,
               .saveToCameraRoll
           ]
           
           // Present the view controller
           present(activityViewController, animated: true)
       }
    
    
    
    
    
    @IBAction func FAQ(_ sender: Any) {
        let faqvc = self.storyboard?.instantiateViewController(identifier: "FAQViewController") as! FAQViewController
        navigationController?.pushViewController(faqvc, animated: true)
    }
}
