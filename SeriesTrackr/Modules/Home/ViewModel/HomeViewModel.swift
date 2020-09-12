//
//  HomeViewModel.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class HomeViewModel {
    let networkService: ParseService
    
    /// TODO: Added trending service as well to the initalizer.
    init(networkService: ParseService) {
        self.networkService = networkService
    }
}
