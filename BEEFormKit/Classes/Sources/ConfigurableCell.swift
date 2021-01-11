//
//  ConfigurableCell.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

private var formItemKey = "FormItemKey"

public protocol ConfigurableCell {

    associatedtype CellData

    static var reuseIdentifier: String { get }
    static var estimatedSize: FormItemLayoutSize { get }
    static var defaultSize: CGSize? { get }
    static var cacheSize: Bool { get }

    func configure(with _: CellData)
}

public extension ConfigurableCell where Self: UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var estimatedSize: FormItemLayoutSize {
        return FormItemLayoutSize(widthDimension: .none, heightDimension: .none)
    }

    static var defaultSize: CGSize? {
        return nil
    }

    static var cacheSize: Bool {
        return true
    }

    /// current collectionView
    var collectionView: UICollectionView? {
      var superview: UIView? = self

      while superview != nil && !(superview is UICollectionView) {
        superview = superview?.superview
      }

      return superview as? UICollectionView
    }

    /// item hashValue
    var itemHashValue: Int {
        set { objc_setAssociatedObject(self, &formItemKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { (objc_getAssociatedObject(self, &formItemKey) as? NSNumber)?.intValue ?? 0 }
    }

}


