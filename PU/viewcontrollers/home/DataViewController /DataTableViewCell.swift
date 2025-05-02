import UIKit
import Kingfisher

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SeparateDataView: UIView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventTime: UILabel!
    @IBOutlet weak var EventPlace: UILabel!
    @IBOutlet weak var EventImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add shadow to SeparateDataView
        SeparateDataView.layer.shadowColor = UIColor.lightGray.cgColor
        SeparateDataView.layer.shadowOpacity = 0.5
        SeparateDataView.layer.shadowOffset = CGSize(width: 0, height: 2)
        SeparateDataView.layer.shadowRadius = 4
        SeparateDataView.layer.masksToBounds = false
        
        // Add border to SeparateDataView
        SeparateDataView.layer.borderWidth = 1.0
        SeparateDataView.layer.borderColor = UIColor.lightGray.cgColor
        SeparateDataView.layer.cornerRadius = 10
        
        // Set content mode for EventImg
        EventImg.contentMode = .scaleAspectFill
        EventImg.clipsToBounds = true
        EventImg.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none // Prevent background color change
        // Check if SeparateDataView is not nil before using it
        if let separateDataView = SeparateDataView {
            // Set up constraints for SeparateDataView
            separateDataView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separateDataView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                separateDataView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                separateDataView.widthAnchor.constraint(equalToConstant: 361.33), // Set fixed width
                separateDataView.heightAnchor.constraint(equalToConstant: 150), // Set fixed height
                separateDataView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        } else {
            print("SeparateDataView is nil")
        }
    }
    
    func configure(with event: Event) {
        EventName.text = event.name
        EventDate.text = event.date
        EventTime.text = event.time
        EventPlace.text = event.place
        
        // Load image from URL asynchronously using Kingfisher
        if let imageURL = URL(string: event.imageURL) {
            EventImg.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print("Image downloaded successfully: \(value.image)")
                    // Image downloaded successfully, do any additional configuration if needed
                case .failure(let error):
                    print("Error downloading image: \(error)")
                    // Image download failed, handle error
                }
            }
        }
    }
}
