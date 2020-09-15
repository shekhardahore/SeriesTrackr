//
//  TrendingShow.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

struct TrendingShow: Hashable {
    
    var showId: String
    var showImage: UIImage?
    
    init(showId: String, showImage: UIImage?) {
        self.showId = showId
        self.showImage = showImage
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(showId)
    }
    
    static func == (lhs: TrendingShow, rhs: TrendingShow) -> Bool {
        lhs.showId == rhs.showId
    }
}
