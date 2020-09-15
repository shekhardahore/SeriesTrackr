//
//  GradientImageView.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 15/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import UIKit

class GradientImageView: UIImageView {
    
    //MARK: - View model
    enum GradientDirection {
        case upDown
        case downUp
        case leftRight
        case rightLeft
        case topLeftBottomRight
        case topRightBottomLeft
        case bottomLeftTopRight
        case bottomRightTopLeft
    }
    
    //MARK: - Properties
    var colors: [UIColor] = [] {
        didSet {
            updateGradient()
        }
    }
    private var cgColors: [CGColor] {
        return colors.map({ $0.cgColor })
    }
    var gradientDirection: GradientDirection = .downUp {
        didSet {
            updateGradient()
        }
    }
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        layer.shouldRasterize = true
        
        return layer
    }()
    
    
    //MARK: UI
    private lazy var overlayView: UIView = { return UIView() }()
    
    
    //MARK: - Constructor
    init(colors: [UIColor], gradientDirection: GradientDirection) {
        super.init(frame: .zero)
        
        self.colors = colors
        self.gradientDirection = gradientDirection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - Lifecycle methods methods
extension GradientImageView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            setupUI()
            updateGradient()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = overlayView.frame
        
    }
    
}


//MARK: - Private methods
private extension GradientImageView {
    
    func setupUI() {
        addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.topAnchor.constraint(equalTo: overlayView.superview!.topAnchor).isActive = true
        overlayView.leftAnchor.constraint(equalTo: overlayView.superview!.leftAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: overlayView.superview!.bottomAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: overlayView.superview!.rightAnchor).isActive = true
        
        overlayView.layer.addSublayer(gradientLayer)
    }
    
    func updateGradient() {
        
        gradientLayer.colors = cgColors
        
        switch gradientDirection {
        case .upDown:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .downUp:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        case .topLeftBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .topRightBottomLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .bottomLeftTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .bottomRightTopLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
        
    }
    
}
