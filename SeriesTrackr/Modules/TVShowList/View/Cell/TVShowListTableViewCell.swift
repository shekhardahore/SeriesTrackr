//
//  TVShowListTableViewCell.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TVShowListTableViewCell: UITableViewCell, Reusable {
    
    var lblTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    var lblYearOfRelease: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    var lblNumberOfSeasons: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    
    var cellModel: TVShowListModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            lblTitle.text = model.titleText
            lblYearOfRelease.text = model.yearOfReleaseText
            lblNumberOfSeasons.text = model.numberOfSeasonsText
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addConstrains()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(lblTitle)
        addSubview(lblYearOfRelease)
        addSubview(lblNumberOfSeasons)
    }
    
    func addConstrains() {
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            lblTitle.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -padding),
            
            lblYearOfRelease.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: padding),
            lblYearOfRelease.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            
            lblNumberOfSeasons.topAnchor.constraint(equalTo: lblYearOfRelease.bottomAnchor, constant: padding),
            lblNumberOfSeasons.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            lblNumberOfSeasons.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -padding)
        ])
        lblTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lblTitle.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        lblTitle.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        lblYearOfRelease.setContentHuggingPriority(.init(rawValue: 500), for: .vertical)
    }
}
