//
//  AddShowCollectionViewCell.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class AddShowCollectionViewCell: UICollectionViewCell, Reusable {
    
    var textField: STTextField = {
        var textField = STTextField()
        return textField
    }()
    
    var lblTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    
    var cellModel: NewTVShowData? {
        didSet {
            guard let model = cellModel else {
                return
            }
            lblTitle.text = model.titleText
            textField.keyboardType = model.inputType.keyboardType()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstrains()
    }
    
    func addViews() {
        addSubview(lblTitle)
        addSubview(textField)
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 5),
            
            textField.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        lblTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
