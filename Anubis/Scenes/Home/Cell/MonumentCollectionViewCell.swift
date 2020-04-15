//
//  MonumentCollectionViewCell.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/15/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit
import Kingfisher

class MonumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monumentImageView: UIImageView!
    @IBOutlet weak var monumentDetailsContainerView: UIView!
    @IBOutlet weak var monumentNameLabel: UILabel!
    
    weak var delegate: MonumentCollectionCellDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureMonumentCell(with imageUrlString: String, monumentName: String) {
        let imageUrl = URL(string: imageUrlString)
        let placeHolderImage = #imageLiteral(resourceName: "placeholder")
        self.monumentImageView.kf.setImage(with: imageUrl, placeholder: placeHolderImage, options: nil, progressBlock: nil) { (result) in
            switch result {
            case .success(let imageResult):
                DispatchQueue.main.async {
                    self.delegate?.didSetCellImage(at: self.indexPath, using: imageResult.image.size.height)
                }
            default: ()
            }
        }
            
        self.monumentNameLabel.text = monumentName
        self.sizeToFit()
        
    }

}
