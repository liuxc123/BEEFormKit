//
//  ViewController.swift
//  FormKit
//
//  Created by liuxc123 on 12/19/2020.
//  Copyright (c) 2020 liuxc123. All rights reserved.
//

import UIKit
import BEEFormKit

class ViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .groupTableViewBackground
        return collectionView
    }()

    lazy var formDirector: FormDirector = {
        return FormDirector(collectionView: collectionView)
    }()

    var dataSource = [
        ["title": "NibCellsController", "class": NibCellsController.self],
        ["title": "AutoLayoutCellsController", "class": AutoLayoutCellsController.self],
        ["title": "FormViewController", "class": FormViewController.self]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FormKit"
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

        for data in dataSource {
            let item = FormItem<ConfigurableViewCell>(value: (data["title"] as? String) ?? "")
                .on(.click) { [weak self] (options) in
                    let vc = (data["class"] as! UIViewController.Type).init()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            section.append(item: item)
        }

        formDirector.append(section: section)
    }

}

