import UIKit

class FAQViewController: UIViewController {
    
    // Back button
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Create a container view for back button
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.layer.borderWidth = 0.0 // Add border
        buttonContainerView.layer.borderColor = UIColor.black.cgColor // Border color
        
        view.addSubview(buttonContainerView)
        
        // Add back button to button container view
        buttonContainerView.addSubview(backButton)
        
        // Create UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stackView to hold questions and answers
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Add constraints for buttonContainerView
        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 60) // Adjust height as needed
        ])
        
        // Add constraints for back button
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor)
        ])
        
        // Add constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add constraints for stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Create and add question-answer pairs
        let faqData = [
            ("1. How do I register for events using the app?", "To register for events, simply download the app, sign in with your college credentials, and browse through the list of available events. Click on the event you're interested in and follow the registration instructions provided."),
            ("2. Can I see a list of all upcoming events on the app?", "Yes, you can view a list of all upcoming events by navigating to the 'Events' section of the app. Here, you'll find details about each event, including date, time, location, and any registration requirements."),
            ("3. Is there a deadline for registration?", "Registration deadlines vary for each event. Please check the event details for specific deadlines."),
            ("4. Can I register for multiple events simultaneously?", "Yes, you can register for multiple events simultaneously using the app. Simply navigate to each event's page and follow the registration process for each one."),
            ("5. Can I share event details with friends through the app?", "Yes, you can share event details with friends through the app by using the built-in sharing feature. Simply select the event you'd like to share and choose the sharing option that suits you best, such as through social media, email, or messaging apps.")
        ]
        
        for (question, answer) in faqData {
            let questionLabel = createLabel(text: question, fontSize: 16, isBold: true)
            stackView.addArrangedSubview(questionLabel)
            
            let answerLabel = createLabel(text: answer, fontSize: 16, isBold: false)
            answerLabel.isHidden = true // Initially hide the answer
            stackView.addArrangedSubview(answerLabel)
            
            // Add tap gesture recognizer to each question label
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            questionLabel.addGestureRecognizer(tapGesture)
            questionLabel.isUserInteractionEnabled = true
        }
        
        // Add border to stackView
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.borderWidth = 0
        stackView.layer.cornerRadius = 0
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let questionLabel = sender.view as? UILabel,
              let index = (questionLabel.superview as? UIStackView)?.arrangedSubviews.firstIndex(of: questionLabel),
              let answerLabel = (questionLabel.superview as? UIStackView)?.arrangedSubviews[index + 1] as? UILabel
        else { return }
        
        // Toggle visibility of the answer label
        answerLabel.isHidden = !answerLabel.isHidden
    }
    
    private func createLabel(text: String, fontSize: CGFloat, isBold: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = 0
        return label
    }
}
