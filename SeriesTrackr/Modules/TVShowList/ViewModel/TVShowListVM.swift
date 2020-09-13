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
    var tvShows: [TVShow]? {
        didSet {
            tvShowListTableViewVM.tvShowData = tvShows
            tvShowFetchComplete?()
        }
    }
    
    var tvShowFetchComplete: (()->())?
    var requestFailure: ((_ errorMessage: String)->())?
    
    init(parseService: ParseService) {
        self.parseService = parseService
        self.tvShowListTableViewVM = TVShowListTableViewVM()
        //  tvShowListCollectionViewVM.delegate = self
    }
    
    func fetchAllShows() {
        parseService.getShowList { [weak self] (result) in
            switch result {
            case .success(let shows):
                self?.tvShows = DataFilterService().filterDuplicates(unfilteredTVShows: shows)
            case .failure(let error):
                print(error.localizedDescription)
                self?.requestFailure?(error.localizedDescription)
            }
        }
    }
}
