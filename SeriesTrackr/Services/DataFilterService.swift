//
//  DataFilterService.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class DataFilterService {
    
    func filterDuplicates(unfilteredTVShows: [TVShow]) -> [TVShow] {
        var filteredTVShows: [TVShow]
        let uniqueShows = unfilteredTVShows.unique {
            $0.title.filter { !$0.isWhitespace }.lowercased()
        }
        filteredTVShows = uniqueShows.filter { $0.title != "" }
        return filteredTVShows
    }
}
