//
//  NibCellsController.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BEEFormKit

class NibCellsController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .groupTableViewBackground
        return collectionView
    }()

    lazy var formDirector: FormDirector = {
        return FormDirector(collectionView: collectionView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nib Cells"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        setupForm()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    func setupForm() {

        let section = FormSection()

        for _ in 0 ..< 10 {

            let model = NibModel(value1: randomString(length: randomInt(min: 20, max: 100)), value2: randomString(length: randomInt(min: 20, max: 100)))
            let item = FormItem<NibCollectionViewCell>(value: model)
            section.append(item: item)
        }

        formDirector.append(section: section)
    }


    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

}
