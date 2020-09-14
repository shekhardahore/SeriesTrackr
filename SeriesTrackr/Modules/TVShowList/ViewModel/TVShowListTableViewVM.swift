//
//  TVShowListTableViewVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

protocol TVShowListViewModelDelegate: class {
    func delete(show: TVShow)
}

class TVShowListTableViewVM {
    
    var tableViewCellVMs: [TVShowListModel] = []
    var tvShowData: [TVShow]
    weak var delegate: TVShowListViewModelDelegate?
    
    init(tvShowData: [TVShow]) {
        self.tvShowData = tvShowData
        tableViewCellVMs = configureCellVM(withShows: tvShowData)
        updateTableView?(false)
    }
    
    var updateTableView: ((_ animate: Bool)->())?
    var searchWith: ((_ filter: String?)->())?
    
    func update(tvShowData: [TVShow]) {
        self.tvShowData = tvShowData
        tableViewCellVMs = configureCellVM(withShows: tvShowData)
        updateTableView?(false)
    }
    
    func configureCellVM(withShows shows: [TVShow]) -> [TVShowListModel] {
        var cellVMs: [TVShowListModel] = []
        for show in shows {
            cellVMs.append(TVShowListModel(show: show))
        }
        return cellVMs
    }
    
    func filtered(with filter: String?) -> [TVShowListModel] {
        return tableViewCellVMs.filter { $0.contains(filter) }
    }
    
    func deleteShow(atIndex index: IndexPath) {
        let deletedShow = tableViewCellVMs.remove(at: index.row)
        if let index = tvShowData.firstIndex(where: {$0.showId == deletedShow.id}) {
            let showToDelete = tvShowData.remove(at: index)
            delegate?.delete(show: showToDelete)
        }
    }
}
