//
//  TVShowListTableViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit
protocol TVShowListTableViewDelegate: class {
    func didDeleteShow(atIndex index: IndexPath)
    func didUpdateWatchStatus(fromIndex: IndexPath, toIndex: IndexPath, newStatus: TVShowWatchStatus?)
}

class TVShowListTableViewController: UITableView {

    class DataSource: UITableViewDiffableDataSource<TVShowListTableViewSectionType, TVShowListModel>  {
        
        weak var dataSourceDelegate: TVShowListTableViewDelegate?
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                    dataSourceDelegate?.didDeleteShow(atIndex: indexPath)
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 0:
                return TVShowListTableViewSectionType.watching.rawValue
            case 1:
                return TVShowListTableViewSectionType.watchLater.rawValue
            case 2:
                return TVShowListTableViewSectionType.watched.rawValue
            default:
                return nil
            }
        }
        
        // MARK: reordering support
        
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
            guard sourceIndexPath != destinationIndexPath else { return }
            guard sourceIndexPath.section != destinationIndexPath.section else { return }
            let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
            
            dataSourceDelegate?.didUpdateWatchStatus(fromIndex: sourceIndexPath, toIndex: destinationIndexPath, newStatus: TVShowWatchStatus(rawValue: destinationIndexPath.section + 1))
            
            var snapshot = self.snapshot()
            if let destinationIdentifier = destinationIdentifier {
                if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
                    let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
                    let isAfter = destinationIndex > sourceIndex &&
                        snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
                        snapshot.sectionIdentifier(containingItem: destinationIdentifier)
                    snapshot.deleteItems([sourceIdentifier])
                    if isAfter {
                        snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
                    } else {
                        snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
                    }
                }
            } else {
                let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
                snapshot.deleteItems([sourceIdentifier])
                snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
            }
            apply(snapshot, animatingDifferences: false)
        }
    }
    
    unowned var viewModel: TVShowListTableViewVM
    var tableViewDataSource: DataSource! = nil
    var searchController = UISearchController(searchResultsController: nil)

    init(viewModel: TVShowListTableViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .insetGrouped)
        isEditing = true
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
        tableViewDataSource.dataSourceDelegate = self
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<TVShowListTableViewSectionType, TVShowListModel>()
        snapshot.appendSections([TVShowListTableViewSectionType.watching, TVShowListTableViewSectionType.watchLater, TVShowListTableViewSectionType.watched])

        snapshot.appendItems(viewModel.watchingShows, toSection: TVShowListTableViewSectionType.watching)
        snapshot.appendItems(viewModel.watchLaterShows, toSection: TVShowListTableViewSectionType.watchLater)
        snapshot.appendItems(viewModel.watchedShows, toSection: TVShowListTableViewSectionType.watched)
        
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func performQuery(with filter: String?) {
        
        let shows = viewModel.filtered(with: filter)
        var snapshot = NSDiffableDataSourceSnapshot<TVShowListTableViewSectionType, TVShowListModel>()
        snapshot.appendSections([TVShowListTableViewSectionType.watching, TVShowListTableViewSectionType.watchLater, TVShowListTableViewSectionType.watched])
        
        snapshot.appendItems(shows.watching, toSection: TVShowListTableViewSectionType.watching)
        snapshot.appendItems(shows.watchLater, toSection: TVShowListTableViewSectionType.watchLater)
        snapshot.appendItems(shows.watched, toSection: TVShowListTableViewSectionType.watched)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TVShowListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = UIContextualAction(style: .normal, title: "add2") { (action, view, completion ) in
            print("add2 called, table is Editing \(tableView.isEditing)")
            tableView.isEditing = false
            
        }
        
//        let delete = UIContextualAction(style: .destructive, title: "delete2") { (action, view, completion ) in
//            print("delete button clicked, is Editing \(tableView.isEditing)")
//            tableView.isEditing = false
//        }
        let config = UISwipeActionsConfiguration(actions: [add])
        return config
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
