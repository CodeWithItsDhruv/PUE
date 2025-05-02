import UIKit
import Firebase
import Kingfisher

class DataViewController: UIViewController {
   
    var selectedCategory: String = ""
    var selectedCellName: String = "" // Add this property to store the selected cell name
    
    var events: [Event] = [] // Array to store fetched events
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var CellName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        CellName.text = selectedCellName
        
        // Fetch events for the selected category
        fetchEventsForCategory()
    }
    
    // Function to fetch events for the selected category from Firebase
    func fetchEventsForCategory() {
        let eventManager = EventManager()
        eventManager.fetchEvents(category: selectedCategory) { [weak self] events in
            self?.events = events
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // Back button action
    @IBAction func BackBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count // Return the number of events
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataTableViewCell
        let event = events[indexPath.row]
        
        // Configure your table view cell with event data
        cell.configure(with: event)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        
        // Instantiate EventRegistrationViewController from storyboard
        if let eventRegistrationVC = storyboard?.instantiateViewController(withIdentifier: "RegCell") as? EventRegistationViewController {
            
            // Set the cellName and selectedEventName properties
            eventRegistrationVC.selectedCellName = selectedCellName
            eventRegistrationVC.selectedEventName = selectedEvent.name // Assuming 'name' is the property that stores the event name
            
            
            // Push EventRegistrationViewController
            navigationController?.pushViewController(eventRegistrationVC, animated: true)
        }
    }
}

