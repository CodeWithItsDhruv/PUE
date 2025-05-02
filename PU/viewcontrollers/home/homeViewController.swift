//
//  homeViewController.swift
//  PU
//
//  Created by DHRUV on 29/03/24.
//

import UIKit
import Firebase

class homeViewController: UIViewController {
    
    
    @IBOutlet weak var wlclbl: UILabel!
    
    @IBOutlet weak var userimg: UIButton!
    
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var messagelbl: UILabel!
    
    var cellimg: [String] = ["technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell","technical_cell","training_and_placement_celll","women_development_cell","social_responsive_cell","research_evelopment_cell","international_relation_cell","grievance_redressal_cell","entrepreneurship_development_centre","career_development_cell"]
    var cellname: [String] = ["TEC","TPC","WDC","SRC","REC","IRC","GRC","EDC","CDC","TEC","TPC","WDC","SRC","REC","IRC","GRC","EDC","CDC"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        
        // Do any additional setup after loading the view.
    }

}

extension homeViewController:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellname.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = COLLECTIONVIEW.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! homeCollectionViewCell
        
        cell.imgview.image = UIImage(named: cellimg[indexPath.row])
        cell.mylbl.text = cellname[indexPath.row]
        cell.imgview.layer.cornerRadius = 10
        return cell
        
    }
    
    //FOR NAVIGATE DATAVIEWCONTROLLER
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          // Get the selected category
          let selectedCategory = cellname[indexPath.row]
          
        // Get the selected cell name
        let selectedCellName = cellname[indexPath.row]
        
        // Instantiate DataViewController
          let dataViewController = self.storyboard?.instantiateViewController(identifier: "DataViewController") as! DataViewController
          
          // Pass the selected category to DataViewController
          dataViewController.selectedCategory = selectedCategory
          dataViewController.selectedCellName = selectedCellName
        
          // Push DataViewController onto the navigation stack
          self.navigationController?.pushViewController(dataViewController, animated: true)
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width)/3
        return CGSize(width: size, height: size)
    }
    
}
