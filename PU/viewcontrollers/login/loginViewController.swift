import UIKit
import Firebase

class loginViewController: UIViewController, OrientationAware {
    
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var myimg: UIImageView!
    
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user is signed in using UserDefaults
        if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
            navigateToTabBar()
        }
        
        emailtxt.delegate = self
        passtxt.delegate = self
        
        // Textfield keyboard handling
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Load GIF image
        let logingif = UIImage.gifImageWithName("login")
        myimg.image = logingif
        
        // Setup orientation notifications
        OrientationHandler.setupOrientationNotifications(for: self)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove orientation notifications
        OrientationHandler.removeOrientationNotifications(for: self)
    }
    
    // MARK: - OrientationAware
    
    func orientationDidChange() {
        if UIDevice.current.orientation.isLandscape {
            // Show an alert or take some action to inform the user
            let alertController = UIAlertController(title: "Orientation Alert", message: "This app is optimized for portrait orientation.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func singupbtn(_ sender: Any) {
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "singupViewController") as? singupViewController
        self.navigationController?.pushViewController(vc3!, animated: true)
    }
    
    @IBAction func loginbtntapped(_ sender: Any) {
        let auth = Auth.auth()
        let defaults = UserDefaults.standard
        
        auth.signIn(withEmail: emailtxt.text!, password: passtxt.text!) { (authResult, error) in
            if error != nil {
                self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
                return
            }
            
            defaults.set(true, forKey: "isUserSignedIn")
            
            // Set UserDefaults to indicate user is signed in
            UserDefaults.standard.set(true, forKey: "isUserSignedIn")
            
            UtilityFunctions().ShowmovingAlert(vc: self, title: "Success", message: "Login successfully") { action in
                self.navigateToTabBar()
            }
        }
        
        if emailtxt.text == "" && passtxt.text == "" {
            self.errorlbl.isHidden = false
            errorlbl.text = "Please Enter Your Email And Password"
        } else if emailtxt.text == "" {
            self.errorlbl.isHidden = false
            errorlbl.text = "Please Enter Your Email"
        } else if passtxt.text == "" {
            self.errorlbl.isHidden = false
            errorlbl.text = "Please Enter Your Password"
        } else {
            self.errorlbl.isHidden = false
        }
    }
    
    // MARK: - Keyboard Handling
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = activeTextField else {
            return
        }
        
        let keyboardY = view.frame.height - keyboardSize.height
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to: view).minY
        
        if view.frame.minY >= 0 {
            if editingTextFieldY > keyboardY - 50 {
                UIView.animate(withDuration: 0.01) {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 90)), width: self.view.bounds.width, height: self.view.bounds.height)
                }
            }
        }
    }
    
    @objc func keyboardHidden(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    // MARK: - Navigation
    
    func navigateToTabBar() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "tabbarViewController") as? tabbarViewController {
            navigationController?.setViewControllers([tabBarController], animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension loginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
