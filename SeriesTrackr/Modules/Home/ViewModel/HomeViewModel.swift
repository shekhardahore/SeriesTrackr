//
//  HomeViewModel.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    var trendingShows: [TrendingShow]

    init(trendingShows: [TrendingShow]) {
        self.trendingShows = trendingShows
    }
}
