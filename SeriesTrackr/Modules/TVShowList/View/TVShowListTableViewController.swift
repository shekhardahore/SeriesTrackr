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
    
    class DataSource: UITableViewDiffableDataSource<TVShowListTableViewSectionType, TVShowListModel> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    var tableViewDataSource: DataSource! = nil
    var searchController = UISearchController(searchResultsController: nil)

    init(viewModel: TVShowListTableViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsContentViewsToSafeArea = true
        delegate = self
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
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<TVShowListTableViewSectionType, TVShowListModel>()
        snapshot.appendSections([TVShowListTableViewSectionType.watched])
        snapshot.appendItems(viewModel.tableViewCellVMs ?? [])
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension TVShowListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = UIContextualAction(style: .normal, title: "add2") { (action, view, completion ) in
            print("add2 called, table is Editing \(tableView.isEditing)")
            tableView.isEditing = false
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: "delete2") { (action, view, completion ) in
            print("delete button clicked, is Editing \(tableView.isEditing)")
            tableView.isEditing = false
        }
        let config = UISwipeActionsConfiguration(actions: [add, delete])
        return config
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
}
