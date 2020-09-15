//
//  TVShowListTableViewDataSource.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class TVShowListTableViewDataSource: UITableViewDiffableDataSource<TVShowWatchStatus, TVShowListModel>  {
    
    weak var dataSourceDelegate: TVShowListTableViewDelegate?
    
    //MARK: TableView Header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TVShowWatchStatus.allCases[section].getSectionHeaderTitle()
    }
    
    //MARK: TableView delete support
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let identifierToDelete = itemIdentifier(for: indexPath) {
                dataSourceDelegate?.didDeleteShow(atIndex: indexPath)
                var snapshot = self.snapshot()
                snapshot.deleteItems([identifierToDelete])
                apply(snapshot)
            }
        }
    }
        
    // MARK: TableView reordering support
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
        guard sourceIndexPath != destinationIndexPath else { return }
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
