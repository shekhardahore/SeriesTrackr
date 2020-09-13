//
//  TVShowListModel.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class TVShowListModel: Hashable {
    
    var titleText: String
    var yearOfReleaseText: String
    var numberOfSeasonsText: String
    
    init(show: TVShow) {
        titleText = show.title
        yearOfReleaseText = "\(show.yearOfRelease)"
        numberOfSeasonsText = "\(show.numberOfSeasons) \((show.numberOfSeasons > 1) ? "seasons".localizedString : "season".localizedString)"
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(titleText)
    }
    
    static func == (lhs: TVShowListModel, rhs: TVShowListModel) -> Bool {
        lhs.titleText == rhs.titleText
    }
}
