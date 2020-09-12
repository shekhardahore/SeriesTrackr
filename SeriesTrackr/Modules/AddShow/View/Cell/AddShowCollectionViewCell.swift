//
//  AddShowCollectionViewCell.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class AddShowCollectionViewCell: UICollectionViewCell, Reusable {
    
    var txtField: STTextField = {
        var textField = STTextField()
        return textField
    }()
    
    var lblTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    var cellModel: AddShowCellVM? {
        didSet {
            guard let model = cellModel else {
                return
            }
            lblTitle.text = model.titleText
            txtField.keyboardType = model.inputType.keyboardType()
            txtField.text = model.inputText
        }
    }
    var textUpdated: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstrains()
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(AddShowCollectionViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func addViews() {
        addSubview(lblTitle)
        addSubview(txtField)
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 5),
            
            txtField.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            txtField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            txtField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            txtField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        lblTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddShowCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtField.layer.borderColor = UIColor.systemBlue.cgColor
        lblTitle.textColor = .systemBlue
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtField.layer.borderColor = UIColor.systemGray3.cgColor
        lblTitle.textColor = .systemGray
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let newValue = textField.text else {
            return
        }
        cellModel?.updateInput(newValue: newValue)
        textUpdated?()
    }
}
