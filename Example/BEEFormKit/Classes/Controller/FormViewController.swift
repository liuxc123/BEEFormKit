//
//  FormViewController.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import UIKit
import BEEFormKit

class FormViewController: UIViewController {

    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .groupTableViewBackground
        return collectionView
    }()

    lazy var formDirector: FormDirector = {
        return FormDirector(collectionView: collectionView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form Views"
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

        let item = FormItem<TextViewCell>(value: "TextViewCell1")
            .on(.click) { (options) in
                print(options.value)
            }
        section.append(item: item)

        let item2 = FormItem<TextViewCell>(value: "TextViewCell2")
            .on(.click) { (options) in
                print(options.value)
            }
        section.append(item: item2)

        let item3 = FormItem<TextViewCell>(value: "TextViewCell3")
            .on(.click) { (options) in
                print(options.value)
            }
        section.append(item: item3)

        formDirector.append(section: section)

    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: FormViewController.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [sectionBackgroundDecoration]

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: FormViewController.sectionBackgroundDecorationElementKind)
        return layout
    }
}
