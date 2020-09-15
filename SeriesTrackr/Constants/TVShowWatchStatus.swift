//
//  TVShowWatchStatus.swift
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
extension TVShowWatchStatus {
    func getSectionHeaderTitle() -> String {
        switch self {
        case .watching:
            return "Currently binging... 🍿"
        case .watchLater:
            return "Watch later"
        case .watched:
            return "It's done. It's over."
        }
    }
}
