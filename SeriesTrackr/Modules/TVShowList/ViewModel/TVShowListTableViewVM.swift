//
//  TVShowListTableViewVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

typealias showsTuple = (watching: [TVShowListModel], watchLater:[TVShowListModel], watched: [TVShowListModel])

class TVShowListTableViewVM {
    
    var watchingShows: [TVShowListModel] = []
    var watchLaterShows: [TVShowListModel] = []
    var watchedShows: [TVShowListModel] = []
    var tvShowData: [TVShow]
    weak var delegate: TVShowListViewModelDelegate?
    
    init(tvShowData: [TVShow]) {
        self.tvShowData = tvShowData
        configureCellVM(withShows: tvShowData)
        updateTableView?(false)
    }
    
    var updateTableView: ((_ animate: Bool)->())?
    var searchWith: ((_ filter: String?)->())?
    
    func update(tvShowData: [TVShow]) {
        self.tvShowData = tvShowData
        configureCellVM(withShows: tvShowData)
        updateTableView?(false)
    }
    
    func configureCellVM(withShows shows: [TVShow]) {
        var watching: [TVShowListModel] = []
        var watched: [TVShowListModel] = []
        var watchLater: [TVShowListModel] = []
        for show in shows {
            if let watchStatus = TVShowWatchStatus(rawValue: show.watchStatus) {
                switch watchStatus {
                case .watching:
                    watching.append(TVShowListModel(show: show))
                case .watchLater:
                    watchLater.append(TVShowListModel(show: show))
                case .watched:
                    watched.append(TVShowListModel(show: show))
                }
            }
        }
        watchingShows = watching
        watchLaterShows = watchLater
        watchedShows = watched
    }
    
    func filtered(with filter: String?) -> showsTuple {
        return (watchingShows.filter { $0.contains(filter) }, watchLaterShows.filter { $0.contains(filter) }, watchedShows.filter { $0.contains(filter) })
    }
        
    func deleteShow(atIndex index: IndexPath) {
        let deletedShow: TVShowListModel?
        switch index.section {
        case 0:
            deletedShow = watchingShows.remove(at: index.row)
        case 1:
            deletedShow = watchLaterShows.remove(at: index.row)
        case 2:
            deletedShow = watchedShows.remove(at: index.row)
        default:
            deletedShow = nil
        }
        if let index = tvShowData.firstIndex(where: {$0.showId == deletedShow?.id}) {
            let showToDelete = tvShowData.remove(at: index)
            delegate?.delete(show: showToDelete)
        }
    }
    
    private func swap(from: IndexPath, to: IndexPath) -> TVShowListModel? {
        let showModel: TVShowListModel?
        switch from.section {
        case 0:
            showModel = watchingShows.remove(at: from.row)
        case 1:
            showModel = watchLaterShows.remove(at: from.row)
        case 2:
            showModel = watchedShows.remove(at: from.row)
        default:
            showModel = nil
        }
        if let show = showModel {
            switch to.section {
            case 0:
                watchingShows.insert(show, at: to.row)
            case 1:
                watchLaterShows.insert(show, at: to.row)
            case 2:
                watchedShows.insert(show, at: to.row)
            default:
                break
            }
        }
        return showModel
    }
    
    func updateWatchingStatus(forShowAtIndex fromIndex: IndexPath, movingToIndexPath toIndex: IndexPath, toStatus status: TVShowWatchStatus) {
 
        if let toUpdateShow = swap(from: fromIndex, to: toIndex), let showToUpdate = tvShowData.first(where: { $0.showId == toUpdateShow.id }) {
            if fromIndex.section == toIndex.section { return }
            delegate?.updateWatchStatus(ofShow: showToUpdate, to: status)
        }
    }
}
