//
//  HomeViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 09/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
        
    var homeCollectionView: UICollectionView
        
    var btnAddNewSeries: STButton = {
        var button = STButton(title: "Add new series to track".localizedString)
        button.addTarget(self, action: #selector(HomeViewController.onAddNewTVShow(_:)), for: .touchUpInside)
        return button
    }()
    
    var btnSeriesLibrary: STButton = {
        var button = STButton(title: "Series library".localizedString)
        button.addTarget(self, action: #selector(HomeViewController.onAllShows(_:)), for: .touchUpInside)
        return button
    }()
    
    enum Route: String {
        case addNewTVShow
        case showAllShows
    }
  
    var viewModel: HomeViewModel
    var router: HomeRouter
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.router = HomeRouter(viewModel: viewModel)
        homeCollectionView = HomeCollecionView(model: viewModel.trendingShows)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "SeriesTrackr"
        addSubviews()
        addConstrains()
    }
    
    func addSubviews() {
        view.addSubview(homeCollectionView)
        view.addSubview(btnAddNewSeries)
        view.addSubview(btnSeriesLibrary)
    }
    
    func addConstrains() {
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            //CollectionView
            homeCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
            
            //add series button
            btnAddNewSeries.topAnchor.constraint(equalTo: homeCollectionView.bottomAnchor, constant: padding),
            btnAddNewSeries.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            btnAddNewSeries.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            btnAddNewSeries.heightAnchor.constraint(equalToConstant: 50),

            //show library button
            btnSeriesLibrary.topAnchor.constraint(equalTo: btnAddNewSeries.bottomAnchor, constant: padding),
            btnSeriesLibrary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            btnSeriesLibrary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            btnSeriesLibrary.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func onAllShows(_ sender: UIButton) {
        router.route(to: Route.showAllShows.rawValue, from: self, data: nil)
    }

    @objc func onAddNewTVShow(_ sender: UIButton) {
        router.route(to: Route.addNewTVShow.rawValue, from: self, data: nil)
    }
}
