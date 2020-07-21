//
//  HomeViewController + UICollectionVIew.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import UIKit

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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let holdErrorMessage = "Please hold the desired monument for options"
        isAnimatingBanner = true
        AnimatiorFactory.shake(view: cell, with: 15).startAnimation()
        AnimatiorFactory.showErrorBanner(in: view, with: holdErrorMessage)
    }
}
