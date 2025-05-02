//
//  GalleryTableViewCell.swift
//  PU
//
//  Created by DHRUV on 09/04/24.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var collection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.delegate = self
        collection.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collection.tag].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        
        // Add border and rounded corners to separate image view
        cell.imgview.layer.borderWidth = 0
        cell.imgview.layer.borderColor = UIColor.red.cgColor
        cell.imgview.layer.cornerRadius = 20
        cell.imgview.clipsToBounds = true
        
        // Set image
        cell.imgview.image = UIImage(named: data[collection.tag].cells[indexPath.row])
        
        return cell
    }
}
