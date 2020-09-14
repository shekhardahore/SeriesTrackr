//
//  NetworkError.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 14/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestFailed, noDataFound, duplicateShow, unknown, cacheMiss
}

extension NetworkError {
    var errorDescription: String {
        switch self {
        case .requestFailed:
            return "Uh oh, we couldn't connect to our servers, please check the network or try again later.".localizedString
        case .noDataFound:
            return "Uh oh, looks like you are yet to add any shows to your library. Goto home page to add some shows to track.".localizedString
        case .duplicateShow:
            return "Hmm, looks like you're already watching this show. Search for it in your library.".localizedString
        default:
            return "Uh oh, something doesn't seem right. Please try again.".localizedString
        }
    }
}
