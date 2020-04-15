//
//  HomeViewController.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/15/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit
import Kingfisher

protocol MonumentCollectionCellDelegate: AnyObject {
    func didSetCellImage(at indexPath: IndexPath, using height: CGFloat)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "29"))
    private let monuments = DataSource.shared.monuments
    private let cellNib = UINib(nibName: "MonumentCollectionViewCell", bundle: nil)
    private let cellReuseId = "MonumentCollectionViewCell"
    private var photosHeights: [Int : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = homeCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
          }
        
        backgroundImageView.contentMode = .scaleAspectFill
        self.homeCollectionView.backgroundView = backgroundImageView
        
        // Register cell classes
        self.homeCollectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseId)
        
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monuments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! MonumentCollectionViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configureMonumentCell(with: monuments[indexPath.row].imagesPaths[0], monumentName: monuments[indexPath.row].name)
        return cell
    }
}

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        // Retrieve the image height
//        let n = Int.random(in: 200...300)
        let height = self.photosHeights[indexPath.row]
        return height ?? 250.0
    }
}

extension HomeViewController: MonumentCollectionCellDelegate {
    func didSetCellImage(at indexPath: IndexPath, using height: CGFloat) {
        let layout = homeCollectionView.collectionViewLayout as? PinterestLayout
        layout?.cache = []
        self.photosHeights [indexPath.row] = height/10
        self.homeCollectionView.collectionViewLayout.invalidateLayout()
        self.homeCollectionView.layoutIfNeeded()
    }
    
}

class CustomImageView : UIImageView {
    var didSetImage = false
    override var image: UIImage? {
        didSet {
            print("image did set")
        }
    }
}
