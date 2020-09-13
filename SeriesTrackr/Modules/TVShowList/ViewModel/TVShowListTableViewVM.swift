//
//  TVShowListTableViewVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class TVShowListTableViewVM {
    
    var tableViewCellVMs: [TVShowListModel]? {
        didSet {
            updateTableView?()
        }
    }
    var tvShowData: [TVShow]? {
        didSet {
            configureCellVM()
        }
    }
    
    var updateTableView: (()->())?
    
    func configureCellVM() {
        var cellVMs: [TVShowListModel] = []
        guard let shows = tvShowData else {
            tableViewCellVMs = cellVMs
            return
        }
        for show in shows {
            cellVMs.append(TVShowListModel(show: show))
        }
        tableViewCellVMs = cellVMs
    }
}
