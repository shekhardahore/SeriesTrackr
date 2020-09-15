//
//  AddShowCellVM.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

class AddShowCellVM: Hashable {
    var titleText: String
    var inputType: InputType
    var inputText: String
    
    init(inputType: InputType, inputData: String) {
        self.inputType = inputType
        self.titleText = inputType.rawValue
        self.inputText = inputData
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(inputType)
    }
    
    static func == (lhs: AddShowCellVM, rhs: AddShowCellVM) -> Bool {
        lhs.inputType == rhs.inputType
    }
    
    func updateInput(newValue: String) {
        inputText = newValue
    }
}
