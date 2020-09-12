//
//  TVShow.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation
import Parse

class TVShow: PFObject, PFSubclassing {
    @NSManaged var showId: String
    @NSManaged var title: String
    @NSManaged var yearOfRelease: Int
    @NSManaged var numberOfSeasons: Int
    static func parseClassName() -> String {
        return ParseClassNames.tvShow
    }
}
