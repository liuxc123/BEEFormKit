//
//  NibCollectionViewCell.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BEEFormKit

struct NibModel {
    var value1: String = ""
    var value2: String = ""
}

class NibCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    // size
    static var estimatedSize: FormItemLayoutSize {
        return .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
    }

    // data
    func configure(with data: NibModel) {
        label1.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 20
        label2.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 20

        label1.text = data.value1
        label2.text = data.value2
    }

}
