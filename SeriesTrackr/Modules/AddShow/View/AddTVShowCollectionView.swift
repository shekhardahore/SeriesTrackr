//
//  AddTVShowCollectionView.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class AddTVShowCollectionView: UICollectionView {
    
    enum Section {
        case tvShowInfo
    }
    unowned var viewModel: AddTVShowCollectionViewVM
    var newDataSource: UICollectionViewDiffableDataSource<Section, AddShowCellVM>! = nil
    
    init(viewModel: AddTVShowCollectionViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        setupCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundColor = .systemBackground
        collectionViewLayout = generateLayout()
        registerReusableCell(AddShowCollectionViewCell.self)
        
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(75))
        let textFieldItem = NSCollectionLayoutItem(layoutSize: itemSize)
        textFieldItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [textFieldItem])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        newDataSource = UICollectionViewDiffableDataSource
            <Section, AddShowCellVM>(collectionView: self) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: AddShowCellVM) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as AddShowCollectionViewCell
                cell.cellModel = detailItem
                cell.textUpdated = { [weak self] in
                    DispatchQueue.main.async {
                        self?.viewModel.inputUpdate()
                    }
                }
                return cell
        }
        let snapshot = snapshotForCurrentState()
        newDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AddShowCellVM> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AddShowCellVM>()
        snapshot.appendSections([Section.tvShowInfo])
        snapshot.appendItems(viewModel.addShowCellVM)
        return snapshot
    }
}
