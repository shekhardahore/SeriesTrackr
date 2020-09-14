//
//  AlertDisplayable.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

protocol AlertDisplayable {
    func displayAlertWith(message: String)
}

extension AlertDisplayable where Self: UIViewController {
    /// Display Alert
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    func displayAlertWith(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
