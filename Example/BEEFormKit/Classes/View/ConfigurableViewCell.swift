//
//  ConfigurableViewCell.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BEEFormKit

class ConfigurableViewCell: UICollectionViewCell, ConfigurableCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static var estimatedSize: FormItemLayoutSize {
        return .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
    }

    static var cacheSize: Bool {
        return false
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}
