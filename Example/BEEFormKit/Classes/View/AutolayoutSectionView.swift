//
//  AutolayoutSectionView.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BEEFormKit

class AutolayoutSectionView: UICollectionReusableView, ConfigurableElementKind {

    @IBOutlet weak var testLabel: UILabel!

    func configure(with text: String) {
        testLabel.text = text
    }

    static var estimatedSize: FormItemLayoutSize {
        return .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        testLabel.numberOfLines = 0
        testLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc func tapAction(_ ges: UIGestureRecognizer) {
        FormElementKindViewAction(key: "click", sender: self, hashValue: itemHashValue, userInfo: ["action": "TapAction"]).invoke()
    }
}
