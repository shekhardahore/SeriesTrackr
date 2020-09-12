//
//  AddTVShowViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class AddTVShowViewController: UIViewController, AlertDisplayable {
    
    var addTVShowCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    var btnSave: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(AddTVShowViewController.onSave(_:)))
        return barButton
    }()
    
    enum Section {
        case tvShowInfo
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AddShowCellVM>! = nil
    var viewModel: AddTVShowViewModel
    
    init(viewModel: AddTVShowViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setNeedsLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add TV Show"
        addSubviews()
        addConstrains()
        configureCollectionView()
        configureDataSource()
        isInputValid()
        viewModel.showAdded = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.hideSpinner()
                self.dismiss(animated: true)
                // show some message
            }
        }
        viewModel.failedToAddShow = { [weak self] (errorMessage: String) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.hideSpinner()
                self.displayAlertWith(title: "Error".localizedString, message: errorMessage)
                self.btnSave.isEnabled = true
            }
        }
    }
    
    func addSubviews() {
        view.addSubview(addTVShowCollectionView)
        self.navigationItem.rightBarButtonItem = btnSave
    }
    
    func addConstrains() {
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            //CollectionView
            addTVShowCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            addTVShowCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addTVShowCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addTVShowCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureCollectionView() {
        addTVShowCollectionView.collectionViewLayout = generateLayout()
        addTVShowCollectionView.registerReusableCell(AddShowCollectionViewCell.self)
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
        dataSource = UICollectionViewDiffableDataSource
            <Section, AddShowCellVM>(collectionView: addTVShowCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: AddShowCellVM) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as AddShowCollectionViewCell
                cell.cellModel = detailItem
                cell.textUpdated = { [weak self] in
                    DispatchQueue.main.async {
                        self?.isInputValid()
                    }
                }
                return cell
        }
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AddShowCellVM> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AddShowCellVM>()
        snapshot.appendSections([Section.tvShowInfo])
        snapshot.appendItems(viewModel.addShowCellVM)
        return snapshot
    }
    
    @objc func onSave(_ sender: UIBarButtonItem) {
        print("onSave")
        btnSave.isEnabled = false
        self.showSpinner()
        viewModel.saveShow()
    }
    
    func isInputValid() {
        btnSave.isEnabled = viewModel.isInputValid()
    }
}
