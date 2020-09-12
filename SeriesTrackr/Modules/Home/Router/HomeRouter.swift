//
//  HomeRouter.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class HomeRouter: Router {

    unowned var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel){
        self.viewModel = viewModel
    }
    
    func route(to routeID: String, from context: UIViewController, data: Any?) {
        guard let route = HomeViewController.Route(rawValue: routeID) else { return }
        switch route {
        case .addNewTVShow:            
            let vc = AddTVShowViewController(viewModel: AddTVShowViewModel())
            let navVC = UINavigationController(rootViewController: vc)
            context.present(navVC, animated: true)
        case .showAllShows:
            print("showAllShows")
        }
    }
}
