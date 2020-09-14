//
//  AddTVShowCollectionViewVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class AddTVShowCollectionViewVM {
    
    var addShowCellVM: [AddShowCellVM]
    weak var delegate: AddTVShowViewModelDelegate?
    
    init() {
        let tvShowName = AddShowCellVM(inputType: .title, inputData: "")
        let tvShowYearOfRelease = AddShowCellVM(inputType: .numberOfSeasons, inputData: "")
        let tvShowNumberOfSeasons = AddShowCellVM(inputType: .yearOfRelease, inputData: "")
        addShowCellVM = [tvShowName, tvShowYearOfRelease, tvShowNumberOfSeasons]
    }
    
    func inputUpdate() {
        
        var isValid = true
        for field in addShowCellVM {
            if field.inputText == "" {
                isValid = false
                break
            }
        }
        delegate?.input(isValid: isValid)
    }
    
    func getShow() -> TVShow {
        
        let show = TVShow()
        for field in addShowCellVM {
            switch field.inputType {
            case .title:
                show.showId = field.inputText.uuidString
                show.title = field.inputText
            case .numberOfSeasons:
                show.numberOfSeasons = Int(field.inputText) ?? 1
            case .yearOfRelease:
                show.yearOfRelease = Int(field.inputText) ?? 1970
            }
        }
        show.watchStatus = TVShowWatchStatus.watching.rawValue
        return show
    }
}
