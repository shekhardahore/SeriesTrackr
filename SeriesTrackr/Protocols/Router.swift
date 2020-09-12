//
//  Router.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit
//Router protocol can be implemented by any module router and used for navigation
protocol Router {
    func route(to routeID: String, from context: UIViewController, data: Any?)
}
