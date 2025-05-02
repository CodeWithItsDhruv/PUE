import UIKit

// MARK: - Data Model

var data = [
    CellData(sectionType: "TEC", cells:  ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]),
    CellData(sectionType: "TPC", cells: ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]),
    CellData(sectionType: "TEC", cells:  ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]),
    CellData(sectionType: "TPC", cells: ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]),
    CellData(sectionType: "TEC", cells:  ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]),
    CellData(sectionType: "TPC", cells: ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"])
]

// MARK: - View Controller

class GalleryViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.sectionHeaderTopPadding = 0
    }
}

// MARK: - Table View Delegate and Data Source

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25 // Set the height of the section header as needed
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground // Change the background color of the section header
        
        let label = UILabel()
        label.text = data[section].sectionType // Set the text of the section header
        label.textColor = UIColor.black // Set the text color of the section header
        label.font = UIFont.boldSystemFont(ofSize: 20) // Set the font of the section header text
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        // Add constraints for the label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GalleryTableViewCell
        cell.collection.tag = indexPath.section
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}
