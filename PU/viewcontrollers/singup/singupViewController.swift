import UIKit
import Firebase

class singupViewController: UIViewController, OrientationAware{

    @IBOutlet weak var myimg: UIImageView!
    @IBOutlet weak var usrtxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var phonetxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var errorlblforsingup: UILabel!

    var activetextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        usrtxt.delegate = self
        emailtxt.delegate = self
        phonetxt.delegate = self
        passtxt.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        let registergif = UIImage.gifImageWithName("register")
        myimg.image = registergif

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardshow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Setup orientation notifications
                OrientationHandler.setupOrientationNotifications(for: self)
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
        
    
    @IBAction func loginbtntapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func registerbtn(_ sender: Any) {

        let defaults = UserDefaults.standard

        // Check if any field is empty
        if usrtxt.text == "" || emailtxt.text == "" || phonetxt.text == "" || passtxt.text == "" {
            showError(message: "Please fill in all fields")
            return
        }

        // If all fields are filled, proceed with sign-up logic
        Service.signUpUser(email: emailtxt.text!, password: passtxt.text!, username: usrtxt.text!, phonenumber: phonetxt.text!) {
            defaults.set(true, forKey: "isUserSignedIn")
            self.navigationController?.popViewController(animated: true)

        } onError: { error in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }

        // Additional sign-up logic can be added here if needed
    }

    func showError(message: String) {
        errorlblforsingup.isHidden = false
        errorlblforsingup.text = message
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardshow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = activetextfield else {
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
}

extension singupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activetextfield = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
