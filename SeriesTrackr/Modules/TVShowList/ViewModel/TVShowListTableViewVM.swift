//
//  TVShowListTableViewVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class TVShowListTableViewVM {
    
    var tableViewCellVMs: [TVShowListModel]?
    var tvShowData: [TVShow]? {
        didSet {
            tableViewCellVMs = configureCellVM(withShows: tvShowData ?? [])
            updateTableView?(false)
        }
    }
    
    var updateTableView: ((_ animate: Bool)->())?
    
    func configureCellVM(withShows shows: [TVShow]) -> [TVShowListModel] {
        var cellVMs: [TVShowListModel] = []
        for show in shows {
            cellVMs.append(TVShowListModel(show: show))
        }
        return cellVMs
    }
    
    func filter(withText text: String) {
        guard var shows = tvShowData, text != "" else {
            tableViewCellVMs = configureCellVM(withShows: tvShowData ?? [])
            updateTableView?(false)
            return
        }
        shows = shows.filter { show in
            return show.title.lowercased().contains(text.lowercased())
        }
        tableViewCellVMs = configureCellVM(withShows: shows)
        updateTableView?(false)
    }
}
