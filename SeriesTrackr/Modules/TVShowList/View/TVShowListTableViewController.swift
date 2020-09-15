//
//  TVShowListTableViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TVShowListTableViewController: UITableView {

    unowned var viewModel: TVShowListTableViewVM
    var tableViewDataSource: DataSource! = nil
    var searchController = UISearchController(searchResultsController: nil)

    init(viewModel: TVShowListTableViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .insetGrouped)
        setupTableView()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
        viewModel.updateTableView = { [weak self] (animate: Bool) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.applySnapshot(animatingDifferences: animate)
            }
        }
        viewModel.searchWith = { [weak self] (filter: String?) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.performQuery(with: filter)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsContentViewsToSafeArea = true
        estimatedRowHeight = 100.0
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView()
        registerReusableCell(TVShowListTableViewCell.self)
    }
    
    func configureDataSource() {
        tableViewDataSource = DataSource(tableView: self) {
                (tableView: UITableView, indexPath: IndexPath, detailItem: TVShowListModel) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TVShowListTableViewCell
                cell.cellModel = detailItem
                return cell
        }
        tableViewDataSource.dataSourceDelegate = self
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<TVShowWatchStatus, TVShowListModel>()
        snapshot.appendSections([.watching, .watchLater, .watched])

        snapshot.appendItems(viewModel.watchingShows, toSection: .watching)
        snapshot.appendItems(viewModel.watchLaterShows, toSection: .watchLater)
        snapshot.appendItems(viewModel.watchedShows, toSection: .watched)
        
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func performQuery(with filter: String?) {
        
        let shows = viewModel.filtered(with: filter)
        var snapshot = NSDiffableDataSourceSnapshot<TVShowWatchStatus, TVShowListModel>()
        snapshot.appendSections([.watching, .watchLater, .watched])
        
        snapshot.appendItems(shows.watching, toSection: .watching)
        snapshot.appendItems(shows.watchLater, toSection: .watchLater)
        snapshot.appendItems(shows.watched, toSection: .watched)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TVShowListTableViewController: TVShowListTableViewDelegate {
    func didUpdateWatchStatus(fromIndex: IndexPath, toIndex: IndexPath, newStatus: TVShowWatchStatus?) {
        if let updatedStatus = newStatus {
            viewModel.updateWatchingStatus(forShowAtIndex: fromIndex, movingToIndexPath: toIndex, toStatus: updatedStatus)
        }
    }
    
    func didDeleteShow(atIndex index: IndexPath) {
        viewModel.deleteShow(atIndex: index)
    }
}
