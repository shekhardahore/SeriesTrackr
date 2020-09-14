//
//  InputType.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

enum InputType: String {
    case title = "Title"
    case numberOfSeasons = "Number of seasons"
    case yearOfRelease = "Year of release"
}

extension InputType {
    func keyboardType() -> UIKeyboardType {
        switch self {
        case .title:
            return .default
        case .numberOfSeasons:
            return .numberPad
        case .yearOfRelease:
            return .default
        }
    }
}
