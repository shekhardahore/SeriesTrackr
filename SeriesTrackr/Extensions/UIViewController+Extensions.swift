//
//  UIViewController+Extensions.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 13/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = .clear
        
        let blurView = UIVisualEffectView()
        blurView.frame.size = CGSize(width: 80, height: 80)
        blurView.center = aView!.center
        blurView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurView.layer.cornerRadius = 8
        blurView.layer.masksToBounds = true
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .black
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(blurView)
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
    
    func hideSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
