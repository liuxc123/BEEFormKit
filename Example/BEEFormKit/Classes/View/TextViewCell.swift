//
//  TextViewCell.swift
//  CollectionViewApp
//
//  Created by liuxc on 2020/12/9.
//

import UIKit
import BEEFormKit

class TextViewCell: UICollectionViewCell, ConfigurableCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .yellow
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.delegate = self
    }

    // size
    static var estimatedSize: FormItemLayoutSize {
        return .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
    }

    // cache size
    static var cacheSize: Bool {
        return false
    }

    // data
    func configure(with text: String) {
        textView.text = text
    }

    // textview delegate
    func textViewDidChange(_ textView: UITextView) {

        // update item value
        FormCellAction(sender: self, value: textView.text ?? "").invoke()

        // update layout
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

}
