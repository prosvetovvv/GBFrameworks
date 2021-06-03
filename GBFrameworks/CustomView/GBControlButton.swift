//
//  GBActionButton.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 31.05.2021.
//

import UIKit

enum SFSymbols: String {
    case stop = "stop.fill"
    case record = "record.circle"
    case path = "point.topleft.down.curvedto.point.bottomright.up"
}

class GBControlButton: UIButton {
    
    // MARK: - Init
    
    init(symbol: SFSymbols) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .black)
        let image = UIImage(systemName: symbol.rawValue, withConfiguration: imageConfiguration)
        let grayImage = image?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        setImage(grayImage, for: .normal)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setup() {
        layer.shouldRasterize = true
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 7
        
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

