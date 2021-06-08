//
//  HomeCell.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 05/06/21.
//

import UIKit

class HomeCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource {

    var images: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(images: [String]) {
        self.images = images
        collectionView.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Collection view delegate datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
//        let image = images[indexPath.row]
//        cell.setup(imageUrl: image)
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        let identifier = String(describing: HomeCVCell.self)
        let nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
    }
    
}


