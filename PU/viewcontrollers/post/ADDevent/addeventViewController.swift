import UIKit
import Firebase // Import Firebase module
import FirebaseStorage
import FirebaseFirestore

class addeventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var eventname: UITextField!
    @IBOutlet weak var eventdate: UITextField!
    @IBOutlet weak var eventtime: UITextField!
    @IBOutlet weak var eventplace: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addimg: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var separateUIView: UIView!
    @IBOutlet weak var separateImageView: UIImageView!
    @IBOutlet weak var separateNameLabel: UILabel!
    @IBOutlet weak var separateDateLabel: UILabel!
    @IBOutlet weak var separateTimeLabel: UILabel!
    @IBOutlet weak var separatePlaceLabel: UILabel!
    @IBOutlet weak var separateimglbl: UILabel!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var activeTextField: UITextField?
    var categoryPicker: UIPickerView!
    let categories = ["TEC","TPC","WDC","SRC","REC","IRC","GRC","EDC","CDC"]
    var selectedCategory: String = "" // Define selectedCategory variable

    // Firebase database reference
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the icon
        let iconImageView = UIImageView(image: UIImage(named: "dropdown_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        categoryTextField.rightView = iconImageView
        categoryTextField.rightViewMode = .always

        // Set up the UIPickerView
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        // Assign categoryPicker as input view for the categoryTextField
        categoryTextField.inputView = categoryPicker

        // Add toolbar with "Done" button to categoryPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        categoryTextField.inputAccessoryView = toolbar
        
        // Firebase database reference
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        // Configure date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Configure time picker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        // Add toolbar with "Done" button to date picker
        let datePickerToolbar = UIToolbar()
        datePickerToolbar.sizeToFit()
        let datePickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneButtonTapped))
        datePickerToolbar.setItems([datePickerDoneButton], animated: false)
        eventdate.inputAccessoryView = datePickerToolbar
        
        // Add toolbar with "Done" button to time picker
        let timePickerToolbar = UIToolbar()
        timePickerToolbar.sizeToFit()
        let timePickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(timePickerDoneButtonTapped))
        timePickerToolbar.setItems([timePickerDoneButton], animated: false)
        eventtime.inputAccessoryView = timePickerToolbar
        
        // Assign date picker to eventdate text field
        eventdate.inputView = datePicker
        
        // Assign time picker to eventtime text field
        eventtime.inputView = timePicker
        
        // Add targets for text fields to update separate UI view in real-time
        eventname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        eventplace.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Configure image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        // Add tap gesture recognizer to the image view
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(imageTapGesture)
        imageView.isUserInteractionEnabled = true
        
        // Add border and rounded corners to image view
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit // Set content mode to scale aspect fit
        imageView.image = UIImage(named: "placeholder_image")
        let customColor = UIColor(red: 51/255, green: 53/255, blue: 122/255, alpha: 1.0)
        imageView.layer.borderColor = customColor.cgColor
        
        // Add shadow to imageView
        imageView.layer.shadowColor = customColor.cgColor
        imageView.layer.shadowOpacity = 10
        imageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageView.layer.shadowRadius = 10
        imageView.layer.masksToBounds = false
        
        // Add border and rounded corners to separate image view
        separateImageView.layer.borderWidth = 0
        separateImageView.layer.borderColor = UIColor.lightGray.cgColor
        separateImageView.layer.cornerRadius = 10
        separateImageView.clipsToBounds = true
        
        // Add shadow to separateUIView
        separateUIView.layer.shadowColor = UIColor.lightGray.cgColor
        separateUIView.layer.shadowOpacity = 0.5
        separateUIView.layer.shadowOffset = CGSize(width: 0, height: 2)
        separateUIView.layer.shadowRadius = 4
        separateUIView.layer.masksToBounds = false
        
        // Add border to separate UIView
        separateUIView.layer.borderWidth = 1.0
        separateUIView.layer.borderColor = UIColor.lightGray.cgColor
        separateUIView.layer.cornerRadius = 10
        
        // Set delegates for text fields
        eventname.delegate = self
        eventdate.delegate = self
        eventtime.delegate = self
        eventplace.delegate = self
        
        // Show the border initially
        imageView.layer.borderWidth = 1.0
        
        // Add observers for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
    }
    
    // MARK: - Actions

    @objc func doneButtonTapped() {
        categoryTextField.resignFirstResponder()
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        categoryTextField.text = categories[selectedRow]
        selectedCategory = categories[selectedRow]
    }

    // MARK: - Image Picker
    
    @objc func imageViewTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            // Adjust content mode to ensure entire image is visible
            imageView.contentMode = .scaleAspectFit
            
            // Hide the border
            imageView.layer.borderWidth = 0
            
            // Remove the addimg label
            dismissAddImgLabel()
            
            // Dismiss the separateimglbl label
            dismissSeparateImgLabel()
            
            messageLabel.text = ""
            updateLabels()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func dismissAddImgLabel() {
        addimg.isHidden = true
    }
    
    func dismissSeparateImgLabel() {
        separateimglbl.isHidden = true
    }
    
    func updateLabels() {
        separateNameLabel.text = eventname.text
        separateDateLabel.text = eventdate.text
        separateTimeLabel.text = eventtime.text
        separatePlaceLabel.text = eventplace.text
        separateImageView.image = imageView.image
        
        // Adjust font size dynamically based on text length
        let maxFontSize: CGFloat = 24
        let minFontSize: CGFloat = 12
        
        separateNameLabel.adjustsFontSizeToFitWidth = true
        separateDateLabel.adjustsFontSizeToFitWidth = true
        separateTimeLabel.adjustsFontSizeToFitWidth = true
        separatePlaceLabel.adjustsFontSizeToFitWidth = true
        
        separateNameLabel.minimumScaleFactor = minFontSize / maxFontSize
        separateDateLabel.minimumScaleFactor = minFontSize / maxFontSize
        separateTimeLabel.minimumScaleFactor = minFontSize / maxFontSize
        separatePlaceLabel.minimumScaleFactor = minFontSize / maxFontSize
    }
    
    // MARK: - Keyboard Handling
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField else {
            return
        }
        
        let textFieldOrigin = activeTextField.convert(activeTextField.bounds.origin, to: nil)
        let distanceToBottom = view.frame.height - textFieldOrigin.y - activeTextField.frame.height
        let keyboardHeight = keyboardFrame.height
        
        if distanceToBottom < keyboardHeight {
            let adjustmentHeight = keyboardHeight - distanceToBottom + 10
            view.frame.origin.y = -adjustmentHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func logoutbtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIButton) {
        // Disable the button to prevent multiple clicks
        addEventButton.isEnabled = false

        // Check if all fields are filled
        guard let eventName = eventname.text, !eventName.isEmpty,
              let eventDate = eventdate.text, !eventDate.isEmpty,
              let eventTime = eventtime.text, !eventTime.isEmpty,
              let eventPlace = eventplace.text, !eventPlace.isEmpty,
              let eventImage = imageView.image
        else {
            messageLabel.text = "Please enter all the details."
            // Re-enable the button
            addEventButton.isEnabled = true
            return
        }

        // Upload event and image
        uploadEvent(eventName: eventName, eventDate: eventDate, eventTime: eventTime, eventPlace: eventPlace, eventImage: eventImage)
    }
    func uploadEvent(eventName: String, eventDate: String, eventTime: String, eventPlace: String, eventImage: UIImage) {
        // Ensure a category is selected
        guard !selectedCategory.isEmpty else {
            messageLabel.text = "Please select a category."
            // Re-enable the button
            addEventButton.isEnabled = true
            return
        }

        // Reference to the Firebase Realtime Database
        let databaseRef = Database.database().reference().child("event").child(selectedCategory.lowercased())

        // Create a unique ID for the event
        let eventId = databaseRef.childByAutoId().key!

        // Convert image to data
        guard let imageData = eventImage.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data.")
            // Re-enable the button
            addEventButton.isEnabled = true
            return
        }

        // Upload image data to Firebase Storage
        let imageFileName = "\(eventId).jpg"
        let imageRef = storageRef.child("eventImages/\(imageFileName)")
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                // Re-enable the button
                self.addEventButton.isEnabled = true
                return
            }

            // Once the image is uploaded, get its download URL
            imageRef.downloadURL { url, error in
                guard let imageURL = url else {
                    print("Error getting image download URL: \(error?.localizedDescription ?? "Unknown error")")
                    // Re-enable the button
                    self.addEventButton.isEnabled = true
                    return
                }

                // Create a dictionary to store event data
                let eventData: [String: Any] = [
                    "name": eventName,
                    "date": eventDate,
                    "time": eventTime,
                    "place": eventPlace,
                    "imageURL": imageURL.absoluteString
                ]

                // Set event data in Firebase Realtime Database
                let eventRef = databaseRef.child(eventId)
                eventRef.setValue(eventData) { error, _ in
                    if let error = error {
                        print("Error uploading event data: \(error.localizedDescription)")
                        // Re-enable the button
                        self.addEventButton.isEnabled = true
                    } else {
                        print("Event data uploaded successfully!")

                        // Navigate to home screen after uploading event
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigateToHomeScreen()
                        }
                    }
                }
            }
        }

        // Observe changes in upload status
        uploadTask.observe(.progress) { snapshot in
            // Update UI to show upload progress if needed
        }

        uploadTask.observe(.success) { snapshot in
            // Handle successful upload if needed
        }
    }



    func navigateToHomeScreen() {
        if let homeScreenVC = storyboard?.instantiateViewController(withIdentifier: "tabbarViewController") as? tabbarViewController {
            navigationController?.setViewControllers([homeScreenVC], animated: true)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateLabels()
    }
    
    @objc func datePickerDoneButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        eventdate.text = formatter.string(from: datePicker.date)
        eventdate.resignFirstResponder()
        updateLabels()
    }
    
    @objc func timePickerDoneButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        eventtime.text = formatter.string(from: timePicker.date)
        eventtime.resignFirstResponder()
        updateLabels()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
