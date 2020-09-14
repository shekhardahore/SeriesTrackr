//
//  AddTVShowViewModel.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class AddTVShowViewModel {
    
    let parseService: ParseService
    var addTVShowCollectionViewVM: AddTVShowCollectionViewVM
    
    var failedToAddShow: ((_ errorMessage: String)->())?
    var showAdded: (()->())?
    var isInputValid: ((_ enableSave: Bool)->())?

    init(parseService: ParseService) {
        self.parseService = parseService
        addTVShowCollectionViewVM = AddTVShowCollectionViewVM()
        addTVShowCollectionViewVM.delegate = self
    }
    
    func saveShow() {
        let show = addTVShowCollectionViewVM.getShow()
        parseService.save(show: show) { [weak self] result in
            switch result {
            case .success(_):
                print("Show saved")
                self?.showAdded?()
            case .failure(let error):
                print(error)
                self?.failedToAddShow?(error.errorDescription)
            }
        }
    }
}

extension AddTVShowViewModel: AddTVShowViewModelDelegate {
    func input(isValid: Bool) {
        isInputValid?(isValid)
    }
}
