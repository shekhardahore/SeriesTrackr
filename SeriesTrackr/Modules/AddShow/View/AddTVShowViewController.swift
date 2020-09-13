//
//  AddTVShowViewController.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class AddTVShowViewController: UIViewController, AlertDisplayable {
    
    var addTVShowCollectionView: UICollectionView
    
    var btnSave: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(AddTVShowViewController.onSave(_:)))
        return barButton
    }()
    
    var viewModel: AddTVShowViewModel
    
    init(viewModel: AddTVShowViewModel) {
        self.viewModel = viewModel
        addTVShowCollectionView = AddTVShowCollectionView(viewModel: viewModel.addTVShowCollectionViewVM)
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
        btnSave.isEnabled = false
        viewModel.isInputValid = { [weak self] (enableSave: Bool) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.btnSave.isEnabled = enableSave
            }
        }
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
    
    @objc func onSave(_ sender: UIBarButtonItem) {
        btnSave.isEnabled = false
        self.showSpinner()
        viewModel.saveShow()
    }
}
