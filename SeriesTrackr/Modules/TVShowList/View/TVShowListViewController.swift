//
//  TVShowListViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TVShowListViewController: UIViewController, AlertDisplayable {

    var tvShowListTableView: TVShowListTableViewController
    var viewModel: TVShowListVM
    private var searchController = UISearchController(searchResultsController: nil)

    init(viewModel: TVShowListVM) {
        self.viewModel = viewModel
        tvShowListTableView = TVShowListTableViewController(viewModel: viewModel.tvShowListTableViewVM)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Show list"
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstrains()
        self.showSpinner()
        viewModel.fetchAllShows()
        viewModel.tvShowFetchComplete = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.hideSpinner()
                self.configureSearchController()
            }
        }
        viewModel.requestFailure = { [weak self] (errorMessage: String) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.hideSpinner()
                self.displayAlertWith(title: "Error".localizedString, message: errorMessage)
            }
        }
    }
    
    func addSubviews() {
        view.addSubview(tvShowListTableView)
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            tvShowListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tvShowListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tvShowListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tvShowListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension TVShowListViewController: UISearchResultsUpdating {
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search TV Show".localizedString
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {                self.viewModel.tvShowListTableViewVM.filter(withText: text)
        }
    }
}
