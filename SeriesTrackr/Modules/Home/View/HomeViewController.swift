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
        
    var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
        
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
    
    enum Section: String, CaseIterable {
        case trending = "Trending now"
    }
    
    enum Route: String {
        case addNewTVShow
        case showAllShows
    }
    
    var trendingShows: [TrendingShows] = [ TrendingShows(showId: "breaking bad", backgroundColor: .systemTeal), TrendingShows(showId: "The boys", backgroundColor: .systemRed), TrendingShows(showId: "Person of Intrest", backgroundColor: .systemGreen) ]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, TrendingShows>! = nil
    var viewModel: HomeViewModel
    var router: HomeRouter

    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.router = HomeRouter(viewModel: viewModel)
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
        configureCollectionView()
        configureDataSource()
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
            homeCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding),
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
    
    func configureCollectionView() {
        homeCollectionView.collectionViewLayout = generateLayout()
        homeCollectionView.registerReusableCell(TrendingCollectionViewCell.self)
    }
    func generateLayout() -> UICollectionViewLayout {
        
//        let syncingBadgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: -0.3, y: 0.3))
//        let syncingBadge = NSCollectionLayoutSupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(20),
//                heightDimension: .absolute(20)),
//            elementKind: AlbumDetailViewController.syncingBadgeKind,
//            containerAnchor: syncingBadgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, TrendingShows>(collectionView: homeCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: TrendingShows) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as TrendingCollectionViewCell
                cell.backgroundColor = detailItem.backgroundColor
                return cell
        }
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, TrendingShows> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TrendingShows>()
        snapshot.appendSections([Section.trending])
        snapshot.appendItems(trendingShows)
        return snapshot
    }
    
    @objc func onAllShows(_ sender: UIButton) {
        router.route(to: Route.showAllShows.rawValue, from: self, data: nil)
    }

    @objc func onAddNewTVShow(_ sender: UIButton) {
        router.route(to: Route.addNewTVShow.rawValue, from: self, data: nil)
    }
}
