//
//  String+Extensions.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var uuidString: String  {
        return self.filter { !$0.isWhitespace }.lowercased()
    }
}
