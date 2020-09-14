//
//  TVShowListVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class TVShowListVM {
    
    var tvShowListTableViewVM: TVShowListTableViewVM
    let parseService: ParseService
    let dataFilterService: DataFilterService
    var tvShows: [TVShow]? {
        didSet {
            tvShowListTableViewVM.tvShowData = tvShows
            tvShowFetchComplete?()
        }
    }
    
    var tvShowFetchComplete: (()->())?
    var requestFailure: ((_ errorMessage: String)->())?
    
    init(parseService: ParseService, dataFilterService: DataFilterService) {
        self.parseService = parseService
        self.dataFilterService = dataFilterService
        self.tvShowListTableViewVM = TVShowListTableViewVM()
        //  tvShowListCollectionViewVM.delegate = self
    }
    
    func fetchAllShows() {
        parseService.getShowList { [weak self] (result) in
            guard let `self` = self else {
                return
            }
            switch result {
            case .success(let shows):
                self.tvShows = self.dataFilterService.filterDuplicates(unfilteredTVShows: shows)
            case .failure(let error):
                switch error {
                case .cacheMiss:
                    //log cache miss
                    break
                default:
                    self.requestFailure?(error.errorDescription)
                }
            }
        }
    }
}
