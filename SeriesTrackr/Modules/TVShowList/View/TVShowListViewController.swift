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
        tvShowListTableView = TVShowListTableViewController(viewModel: viewModel.tvShowListTableViewVM )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Series library"
        view.backgroundColor = .systemGray6
        addSubviews()
        addConstrains()
        configureNavigationItem()
        configureKeyboardEvents()
        showSpinner()
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
                self.displayAlertWith(message: errorMessage)
            }
        }
    }
    
    func addSubviews() {
        view.addSubview(tvShowListTableView)
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            tvShowListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tvShowListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tvShowListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tvShowListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        if let keyBoardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardSize.height, right: 0)
            tvShowListTableView.contentInset = contentInsets
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        tvShowListTableView.contentInset = UIEdgeInsets.zero
    }
    
    func configureNavigationItem() {
        let editingItem = UIBarButtonItem(title: tvShowListTableView.isEditing ? "Done".localizedString : "Edit".localizedString, style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItems = [editingItem]
    }
    
    @objc func toggleEditing() {
        tvShowListTableView.setEditing(!tvShowListTableView.isEditing, animated: true)
        configureNavigationItem()
    }
}

extension TVShowListViewController: UISearchResultsUpdating {
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search series".localizedString
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {                self.viewModel.tvShowListTableViewVM.searchWith?(text)
        }
    }
}
