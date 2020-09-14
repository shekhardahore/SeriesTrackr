//
//  TVShowListTableViewSectionType.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

enum TVShowWatchStatus: Int {
    case watching = 1
    case watchLater = 2
    case watched = 3
}

enum TVShowListTableViewSectionType: String {
    case watching = "Currently binging... 🍿"
    case watchLater = "Watch later"
    case watched = "It's done. It's over."
}
