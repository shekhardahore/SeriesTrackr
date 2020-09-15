//
//  HomeCollecionView.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class HomeCollecionView: UICollectionView {
    
    enum Section: String, CaseIterable {
        case trending = "Trending now 📈"
    }
    
    var homeDataSource: UICollectionViewDiffableDataSource<Section, TrendingShow>! = nil
    
    var trendingShows: [TrendingShow]
    
    init(model: [TrendingShow]) {
        trendingShows = model
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundColor = .systemGray6
        configureCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        collectionViewLayout = generateLayout()
        registerReusableCell(TrendingCollectionViewCell.self)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalHeight(1))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        homeDataSource = UICollectionViewDiffableDataSource
            <Section, TrendingShow>(collectionView: self) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: TrendingShow) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as TrendingCollectionViewCell
                cell.model = detailItem
                return cell
        }
        let snapshot = snapshotForCurrentState()
        homeDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, TrendingShow> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TrendingShow>()
        snapshot.appendSections([Section.trending])
        snapshot.appendItems(trendingShows)
        return snapshot
    }
}
