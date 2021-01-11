//
//  FormItemSizeCalculator.swift
//  FormKit
//
//  Created by liuxc on 2020/12/18.
//

import UIKit

open class FormItemSizeCalculator: ItemSizeCalculator {

    private(set) weak var collectionView: UICollectionView?

    public init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }

    open func size(forItem item: Item, at indexPath: IndexPath) -> CGSize {

        guard let collectionView = collectionView else { return .zero }

        let estimatedSize  = item.estimatedSize
        let isCacheSize = item.cacheSize
        var size = collectionView.bounds.size

        switch estimatedSize.widthDimension {
            case let .fractionalWidth(dimension): size.width = size.width * dimension
            case let .fractionalHeight(dimension): size.width = size.height * dimension
            case let .absolute(dimension): size.width = dimension
            case let .estimated(dimension): size.width = dimension
            default: break
        }

        switch estimatedSize.heightDimension {
            case let .fractionalWidth(dimension): size.height = size.width * dimension
            case let .fractionalHeight(dimension): size.height = size.height * dimension
            case let .absolute(dimension): size.height = dimension
            case let .estimated(dimension): size.height = dimension
            default: break
        }

        // Fixed width
        if !estimatedSize.widthDimension.isEstimated && estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForCell(withIdentifier: item.reuseIdentifier, indexPath: indexPath, fixedWidth: size.width, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        // Fixed height
        if estimatedSize.widthDimension.isEstimated && !estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForCell(withIdentifier: item.reuseIdentifier, indexPath: indexPath, fixedHeight: size.height, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        // Dynamic size
        if estimatedSize.widthDimension.isEstimated && estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForCell(withIdentifier: item.reuseIdentifier, indexPath: indexPath, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        return size
    }

    public func size(forItem item: ElementKindItem, at indexPath: IndexPath) -> CGSize {

        guard let collectionView = collectionView else { return .zero }

        let estimatedSize  = item.estimatedSize
        let isCacheSize = item.cacheSize

        var size = collectionView.bounds.size

        switch estimatedSize.widthDimension {
            case let .fractionalWidth(dimension): size.width = size.width * dimension
            case let .fractionalHeight(dimension): size.width = size.height * dimension
            case let .absolute(dimension): size.width = dimension
            case let .estimated(dimension): size.width = dimension
            default: break
        }

        switch estimatedSize.heightDimension {
            case let .fractionalWidth(dimension): size.height = size.width * dimension
            case let .fractionalHeight(dimension): size.height = size.height * dimension
            case let .absolute(dimension): size.height = dimension
            case let .estimated(dimension): size.height = dimension
            default: break
        }

        // Fixed width
        if !estimatedSize.widthDimension.isEstimated && estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForElementOfKindView(withIdentifier: item.reuseIdentifier, kind: item.kind, indexPath: indexPath, fixedWidth: size.width, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        // Fixed height
        if estimatedSize.widthDimension.isEstimated && !estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForElementOfKindView(withIdentifier: item.reuseIdentifier, kind: item.kind, indexPath: indexPath, fixedHeight: size.height, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        // Dynamic size
        if estimatedSize.widthDimension.isEstimated && estimatedSize.heightDimension.isEstimated {
            size = collectionView.ar_sizeForElementOfKindView(withIdentifier: item.reuseIdentifier, kind: item.kind, indexPath: indexPath, isCacheSize: isCacheSize, configuration: { (cell) in
                item.configure(cell!)
            })
        }

        return size
    }

    open func invalidate() {}

}
