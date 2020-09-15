//
//  TVShowListViewModelDelegate.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

protocol TVShowListViewModelDelegate: class {
    func delete(show: TVShow)
    func updateWatchStatus(ofShow show: TVShow, to: TVShowWatchStatus)
}
