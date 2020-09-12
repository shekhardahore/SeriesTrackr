//
//  TrendingShows.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TrendingShows: Hashable {
    var showId: String
    var backgroundColor: UIColor
    init(showId: String, backgroundColor: UIColor) {
        self.showId = showId
        self.backgroundColor = backgroundColor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(showId)
    }
    
    static func == (lhs: TrendingShows, rhs: TrendingShows) -> Bool {
        lhs.showId == rhs.showId
    }
}
