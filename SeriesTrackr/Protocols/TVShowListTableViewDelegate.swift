//
//  TVShowListTableViewDelegate.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

protocol TVShowListTableViewDelegate: class {
    func didDeleteShow(atIndex index: IndexPath)
    func didUpdateWatchStatus(fromIndex: IndexPath, toIndex: IndexPath, newStatus: TVShowWatchStatus?)
}
