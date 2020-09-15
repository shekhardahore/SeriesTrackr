//
//  TrendingCollectionViewCell.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell, Reusable {
    
    var imgShow: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var model: TrendingShow? {
        didSet {
            imgShow.image = model?.showImage
            imgShow.contentMode = .scaleAspectFit
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstrains()
        //imgShow.frame = contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(imgShow)
    }
    func addConstrains() {
        NSLayoutConstraint.activate([
            imgShow.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgShow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgShow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imgShow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
