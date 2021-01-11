//
//  AutoLayoutCellsController.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BEEFormKit

class AutoLayoutCellsController: UIViewController {

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
        self.title = "AutoLayout Cells"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        setupForm()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    func setupForm() {

        let header = FormElementKindItem<AutolayoutSectionView>(kind: UICollectionView.elementKindSectionHeader, value: "My Header My HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy HeaderMy Header")
            .on("click") { (options) in
                print(options.value)
            }

        let footer = FormElementKindItem<AutolayoutSectionView>(kind: UICollectionView.elementKindSectionFooter, value: "My FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy FooterMy Footer")
            .on("click") { (options) in
                print(options.value)
            }

        let section = FormSection(items: [], elementKindItems: [header, footer])

        let item = FormItem<ConfigurableViewCell>(value: "111111")
            .on(.click) { (options) in
                print(options.value)
            }
        section.append(item: item)

        formDirector.append(section: section)
    }

}

