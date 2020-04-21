//
//  OptionsView.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit

protocol OptionsViewDelegate: AnyObject {
    func didTapDirectionsButton(at indexPath: IndexPath)
    func didTapSaveButton(at indexPath: IndexPath)
    func didTapARButton(at indexPath: IndexPath)
    func didTapCancelButton()
}

class OptionsView: UIVisualEffectView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    
    var indexPath: IndexPath?
    weak var delegate: OptionsViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        commonInit()
        
    }
    
    fileprivate func commonInit() {
        clipsToBounds = true
        self.layer.cornerRadius = 16
    
        Bundle.main.loadNibNamed("OptionsView", owner: self, options: nil)
        contentView.addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        directionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        ARButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapDirectionsButton(at: indexPath)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapSaveButton(at: indexPath)
    }
    
    @IBAction func arButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapARButton(at: indexPath)
    }
}
