import UIKit
import Firebase

class EventRegistationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var CellName: UILabel!
    @IBOutlet weak var Titlelbl: UILabel!
    @IBOutlet weak var registerimg: UIImageView!
    @IBOutlet weak var eventname: UITextField!
    @IBOutlet weak var studentname: UITextField!
    @IBOutlet weak var universitymail: UITextField!
    @IBOutlet weak var persnolmail: UITextField!
    @IBOutlet weak var whatsappnum: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var Institute: UITextField!
    
    let institutes = ["AHMC", "APC", "COA", "DAM", "DPHS", "JNHMC", "PIAS", "PIASR", "PIAR", "PlArts", "PIA", "PlAyuR", "PIBA", "PIC", "PICA", "PID", "АНМС", "PIET", "PIET - DS", "PIET - MBA", "PIET - MCA", "РІНМСТ", "PIL", "PILIS", "PIM", "PIMR", "PIM - PGDM", "PIMSR", "PIN", "P/Pharmacy", "PIPR", "PIPT", "PIPH", "PISW", "PIT", "PPI", "RHMC", "SOP", "PIHR", "IPS", "PIPER", "PIPTR"]
    
    let pickerView = UIPickerView()
    let toolbar = UIToolbar()
    
    var selectedEventName: String?
    var selectedCellName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CellName.text = selectedCellName
        
        eventname.text = selectedEventName
        eventname.isEnabled = false
        
        let registergif = UIImage.gifImageWithName("Loading")
        registerimg.image = registergif
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        // Assign picker view as input view for Institute text field
        Institute.inputView = pickerView
        Institute.inputAccessoryView = toolbar
        
        eventname.delegate = self
        studentname.delegate = self
        universitymail.delegate = self
        persnolmail.delegate = self
        whatsappnum.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Additional logic to display picker view when tapping on Institute text field
        let instituteTapGesture = UITapGestureRecognizer(target: self, action: #selector(instituteTextFieldTapped))
        Institute.addGestureRecognizer(instituteTapGesture)
        Institute.isUserInteractionEnabled = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return institutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return institutes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCellName = institutes[row]
        Institute.text = selectedCellName // Update text field with selected institute
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        if let activeField = findFirstResponder() {
            let bottomOfTextField = activeField.convert(activeField.bounds, to: view).maxY
            let topOfKeyboard = keyboardFrame.origin.y
            let distance = bottomOfTextField - topOfKeyboard
            
            if distance > 0 {
                view.frame.origin.y -= distance
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func findFirstResponder() -> UITextField? {
        for textField in [eventname, studentname, universitymail, persnolmail, whatsappnum] {
            if textField?.isFirstResponder ?? false {
                return textField
            }
        }
        return nil
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        registerButton.isEnabled = false
        
        uploadDataToFirebase { success in
            DispatchQueue.main.async {
                self.registerButton.isEnabled = true
                
                if success {
                    if let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarViewController") as? tabbarViewController {
                        self.navigationController?.setViewControllers([HomeVC], animated: true)
                    }
                } else {
                    self.showAlert(message: "Failed to register. Please try again.")
                }
            }
        }
    }
    
    func uploadDataToFirebase(completion: @escaping (Bool) -> Void) {
        guard let studentName = studentname.text, !studentName.isEmpty,
              let universityMail = universitymail.text, !universityMail.isEmpty,
              let personalMail = persnolmail.text, !personalMail.isEmpty,
              let cellName = CellName.text, !cellName.isEmpty,
              let whatsappNumber = whatsappnum.text, !whatsappNumber.isEmpty,
              let eventName = eventname.text, !eventName.isEmpty else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference()
        let registrationRef = ref.child("Registration").child(cellName).child(eventName).childByAutoId()
        let registrationData = [
            "eventName": eventName,
            "studentName": studentName,
            "universityMail": universityMail,
            "personalMail": personalMail,
            "instituteName": cellName,
            "whatsappNumber": whatsappNumber
        ]
        registrationRef.setValue(registrationData) { error, _ in
            if let error = error {
                print("Error uploading data to Firebase: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func instituteTextFieldTapped() {
        Institute.becomeFirstResponder() // Show picker view
    }
}
