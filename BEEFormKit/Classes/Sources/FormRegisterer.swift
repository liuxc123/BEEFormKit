//
//  FormRegisterer.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

class FormRegisterer {

    private var registeredIds = Set<String>()
    private var registeredElementKindIds = [String: Set<String>]()
    private weak var collectionView: UICollectionView?

    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    func register(cellType: AnyClass, forCellReuseIdentifier reuseIdentifier: String, for indexPath: IndexPath) {

        if registeredIds.contains(reuseIdentifier) {
            return
        }

        let bundle = Bundle(for: cellType)


        // we hope that cell's xib file has name that equals to cell's class name
        // in that case we could register nib
        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            collectionView?.register(UINib(nibName: reuseIdentifier, bundle: bundle), forCellWithReuseIdentifier: reuseIdentifier)
        // otherwise, register cell class
        } else {
            collectionView?.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }

        registeredIds.insert(reuseIdentifier)
    }


    func register(elementKindType: AnyClass, kind: String, reuseIdentifier: String, for indexPath: IndexPath) {

        if registeredElementKindIds.contains(where: { $0.key == kind && $0.value.contains(reuseIdentifier) }) {
            return
        }

        let bundle = Bundle(for: elementKindType)

        // in that case we could register nib
        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            collectionView?.register(UINib(nibName: reuseIdentifier, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        // otherwise, register view class
        } else {
            collectionView?.register(elementKindType, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        }

        var set = registeredElementKindIds[kind] ?? Set<String>()
        set.insert(reuseIdentifier)
        registeredElementKindIds[kind] = set

    }
}



