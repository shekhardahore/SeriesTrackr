//
//  TVShowListTableViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

enum TVShowListTableViewSectionType {
    case watching
    case watchLater
    case watched
}

class TVShowListTableViewController: UITableView {
    
    unowned var viewModel: TVShowListTableViewVM
    var tableViewDataSource: UITableViewDiffableDataSource<TVShowListTableViewSectionType, TVShowListModel>! = nil
    
    init(viewModel: TVShowListTableViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
        setupTableView()
        configureDataSource()
        snapshotForCurrentState()
        viewModel.updateTableView = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.snapshotForCurrentState()
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
        tableViewDataSource = UITableViewDiffableDataSource
            <TVShowListTableViewSectionType, TVShowListModel>(tableView: self) {
                (tableView: UITableView, indexPath: IndexPath, detailItem: TVShowListModel) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TVShowListTableViewCell
                cell.cellModel = detailItem
                return cell
        }
    }
    
    func snapshotForCurrentState() {
        var snapshot = NSDiffableDataSourceSnapshot<TVShowListTableViewSectionType, TVShowListModel>()
        snapshot.appendSections([TVShowListTableViewSectionType.watched])
        snapshot.appendItems(viewModel.tableViewCellVMs ?? [])
        tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
