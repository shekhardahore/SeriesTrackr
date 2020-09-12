//
//  AddTVShowViewModel.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class AddTVShowViewModel {
    
    var addShowCellVM: [AddShowCellVM]
    let parseService: ParseService
    
    var failedToAddShow: ((_ errorMessage: String)->())?
    var showAdded: (()->())?
    
    init(parseService: ParseService) {
        self.parseService = parseService
        let tvShowName = AddShowCellVM(inputType: .title, inputData: "")
        let tvShowYearOfRelease = AddShowCellVM(inputType: .numberOfSeasons, inputData: "")
        let tvShowNumberOfSeasons = AddShowCellVM(inputType: .yearOfRelease, inputData: "")
        addShowCellVM = [tvShowName, tvShowYearOfRelease, tvShowNumberOfSeasons]
    }
    
    func isInputValid() -> Bool {
        
        var isValid = true
        for field in addShowCellVM {
            if field.inputText == "" {
                isValid = false
                break
            }
        }
        return isValid
    }
    
    func getShow() -> TVShow {
        
        let show = TVShow()
        for field in addShowCellVM {
            switch field.inputType {
            case .title:
                show.showId = field.inputText.filter { !$0.isWhitespace }.lowercased()
                show.title = field.inputText
            case .numberOfSeasons:
                show.numberOfSeasons = Int(field.inputText) ?? 1
            case .yearOfRelease:
                show.yearOfRelease = Int(field.inputText) ?? 1970
            }
        }
        return show
    }
    
    func saveShow() {
        let show = getShow()
        parseService.save(show: show) { [weak self] result in
            switch result {
            case .success(_):
                print("Show saved")
                self?.showAdded?()
            case .failure(let error):
                print(error)
                self?.failedToAddShow?(error.localizedDescription)
            }
        }
    }
}
