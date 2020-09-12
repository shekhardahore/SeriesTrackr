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
        
    var btnAddNewTVShow: STButton = {
        var button = STButton(title: "Add new TV show")
        button.addTarget(self, action: #selector(HomeViewController.onAddNewTVShow(_:)), for: .touchUpInside)
        return button
    }()
    
    var btnAllShows: STButton = {
        var button = STButton(title: "All shows")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "SeriesTrackr"
        addSubviews()
        addConstrains()
        configureCollectionView()
        configureDataSource()
    }
    
    func addSubviews() {
        view.addSubview(homeCollectionView)
        view.addSubview(btnAddNewTVShow)
        view.addSubview(btnAllShows)
    }
    
    func addConstrains() {
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            //CollectionView
            homeCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
            
            //Add TV show button
            btnAllShows.topAnchor.constraint(equalTo: homeCollectionView.bottomAnchor, constant: padding),
            btnAllShows.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            btnAllShows.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            btnAllShows.heightAnchor.constraint(equalToConstant: 50),
            
            //Show TV shows button
            btnAddNewTVShow.topAnchor.constraint(equalTo: btnAllShows.bottomAnchor, constant: padding),
            btnAddNewTVShow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            btnAddNewTVShow.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            btnAddNewTVShow.heightAnchor.constraint(equalToConstant: 50)
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
    
    func addData(title: String, numberOfSeasons: Int, yearOfRelease: Int) {
        
        //MARK: Important point
        /*
         Make sure when you are creating a show that the showId is assigned. If not, then throw error. NSManagedObjects cannot have didset or get properties so find a way around it.
         */
        let objectId = title.filter { !$0.isWhitespace }.lowercased()

        let show = TVShow()
        show.showId = objectId
        show.title = title
        show.numberOfSeasons = numberOfSeasons
        show.yearOfRelease = yearOfRelease

        ParseService.save(show: show) { result in
            switch result {
            case .success(_):
                print("Show saved")
            case .failure(let error):
                print(error)
            }
        }
    }
    @objc func onAddNewTVShow(_ sender: UIButton) {
        router.route(to: Route.addNewTVShow.rawValue, from: self, data: nil)
//        let title = "The Boys"
//        let onjectId = title.filter { !$0.isWhitespace }.lowercased()
//
//        let show = TVShow()
//        show.showId = onjectId
//        show.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
//        show.numberOfSeasons = 2
//        show.yearOfRelease = 2019
//
//
//
//        ParseService.checkForDuplicate(show: show) { result in
//            print(result)
//        }
//
//        ParseService.getShowList { result in
//            switch result {
//            case .success(let shows):
//                for show in shows {
//                    print(show["title"] ?? "No title found///")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
