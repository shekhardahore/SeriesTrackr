//
//  SceneDelegate.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 09/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        setupNavigationBarApperance()
        let navVC = UINavigationController(rootViewController: getRootViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

    func getRootViewController() -> HomeViewController {
        let viewModel = HomeViewModel(trendingShows: loadTrendingShows())
        let HomeVC = HomeViewController(viewModel: viewModel)
        return HomeVC
    }
    
    func loadTrendingShows() -> [TrendingShow] {
        return [TrendingShow(showId: "rickandmorty", showImage: UIImage(named: "rickandmorty2")),
                TrendingShow(showId: "iasp", showImage: UIImage(named: "iasp2")),
                TrendingShow(showId: "breakingbad", showImage: UIImage(named: "breakingbad2")),
                TrendingShow(showId: "theboys", showImage: UIImage(named: "theboys2")),
                TrendingShow(showId: "barry", showImage: UIImage(named: "barry2"))
            ]
    }
    
    func setupNavigationBarApperance() {
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

