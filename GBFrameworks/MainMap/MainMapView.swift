//
//  MapView.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 28.05.2021.
//

import UIKit
import MapKit

class MainMapView: UIView {
    let mapView = MKMapView()
    let stackView = UIStackView()
    let routeButton = GBControlButton(symbol: .path)
    let recordButton = GBControlButton(symbol: .record)
    let stopButton = GBControlButton(symbol: .stop)
    
    var padding: CGFloat {
        frame.width / CGFloat(stackView.subviews.count + 1)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupMapView()
        setupStackView()
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
    }
    
    private func setupStackView() {
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(routeButton)
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(stopButton)
        
        mapView.addSubview(stackView)
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}

