//
//  FormDirector.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

/**
    Responsible for collection view's datasource and delegate.
 */
open class FormDirector: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    open private(set) weak var collectionView: UICollectionView?
    open fileprivate(set) var sections = [FormSection]()

    private weak var scrollDelegate: UIScrollViewDelegate?
    private var formRegisterer: FormRegisterer?
    public private(set) var itemSizeCalculator: ItemSizeCalculator?
    private var sectionsIndexTitlesIndexes: [Int]?

    open var isEmpty: Bool {
        return sections.isEmpty
    }

    public init(
        collectionView: UICollectionView,
        scrollDelegate: UIScrollViewDelegate? = nil,
        shouldUseAutomaticCellRegistration: Bool = true,
        itemSizeCalculator: ItemSizeCalculator?)
    {
        super.init()

        if shouldUseAutomaticCellRegistration {
            self.formRegisterer = FormRegisterer(collectionView: collectionView)
        }

        self.itemSizeCalculator = itemSizeCalculator
        self.scrollDelegate = scrollDelegate
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: FormKitNotifications.CellAction), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: FormKitNotifications.ElementKindAction), object: nil)
    }

    public convenience init(
        collectionView: UICollectionView,
        scrollDelegate: UIScrollViewDelegate? = nil,
        shouldUseAutomaticCellRegistration: Bool = true,
        shouldUseItemCellSizeCalculation: Bool = true)
    {
        let sizeCalculator: FormItemSizeCalculator? = shouldUseItemCellSizeCalculation
            ? FormItemSizeCalculator(collectionView: collectionView)
            : nil

        self.init(
            collectionView: collectionView,
            scrollDelegate: scrollDelegate,
            shouldUseAutomaticCellRegistration: shouldUseAutomaticCellRegistration,
            itemSizeCalculator: sizeCalculator
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open func reload() {
        collectionView?.reloadData()
    }

    // MARK: - Private

    private func item(at indexPath: IndexPath) -> Item? {
        if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].items.count {
            return sections[indexPath.section].items[indexPath.row]
        }
        return nil
    }

    private func elementKindItem(at indexPath: IndexPath, kind: String) -> ElementKindItem? {
        if indexPath.section < sections.count, let item = sections[indexPath.section].elementKindItems.filter({ $0.kind == kind }).first {
            return item
        }
        return nil
    }

    private func elementKindItem(for hashValue: Int) -> (ElementKindItem, Int)? {
        for (i, section) in sections.enumerated() {
            for item in section.elementKindItems {
                if item.hashValue == hashValue {
                    return (item, i)
                }
            }
        }
        return nil
    }

    // MARK: Public

    @discardableResult
    open func invoke(
        action: FormItemActionType,
        cell: UICollectionViewCell?, indexPath: IndexPath,
        userInfo: [AnyHashable: Any]? = nil) -> Any?
    {
        guard let item = item(at: indexPath) else { return nil }
        return item.invoke(
            action: action,
            cell: cell,
            path: indexPath,
            userInfo: userInfo
        )
    }

    @discardableResult
    open func invoke(
        action: FormElementKindItemActionType,
        view: UICollectionReusableView?,
        kind: String,
        indexPath: IndexPath,
        userInfo: [AnyHashable: Any]? = nil) -> Any?
    {
        guard let item = elementKindItem(at: indexPath, kind: kind) else { return nil }
        return item.invoke(
            action: action,
            view: view,
            kind: kind,
            path: indexPath,
            userInfo: userInfo
        )
    }

    open override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
    }

    open override func forwardingTarget(for selector: Selector) -> Any? {
        return scrollDelegate?.responds(to: selector) == true
            ? scrollDelegate
            : super.forwardingTarget(for: selector)
    }

    // MARK: - Internal

    func hasAction(_ action: FormItemActionType, atIndexPath indexPath: IndexPath) -> Bool {
        guard let item = item(at: indexPath) else { return false }
        return item.has(action: action)
    }

    @objc
    func didReceiveAction(_ notification: Notification) {

        if let action = notification.object as? FormCellAction, let indexPath = collectionView?.indexPath(for: action.cell)  {
            invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath, userInfo: notification.userInfo)
            return
        }
        if let action = notification.object as? FormElementKindViewAction, let item = elementKindItem(for: action.hashValue) {
            invoke(action: .custom(action.key), view: action.view, kind: item.0.kind, indexPath: IndexPath(item: 0, section: item.1), userInfo: notification.userInfo)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout - configuration

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]

        if itemSizeCalculator != nil {
            formRegisterer?.register(cellType: item.cellType, forCellReuseIdentifier: item.reuseIdentifier, for: indexPath)
        }

        return item.defaultSize
            ?? itemSizeCalculator?.size(forItem: item, at: indexPath)
            ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let item = sections[section].elementKindItems.filter({ $0.kind == UICollectionView.elementKindSectionHeader }).first else {
            return .zero
        }

        if itemSizeCalculator != nil {
            formRegisterer?.register(elementKindType: item.elementKindType, kind: item.kind, reuseIdentifier: item.reuseIdentifier, for: IndexPath(item: 0, section: section))
        }

        return item.defaultSize
            ?? itemSizeCalculator?.size(forItem: item, at: IndexPath(item: 0, section: section))
            ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let item = sections[section].elementKindItems.filter({ $0.kind == UICollectionView.elementKindSectionFooter }).first else {
            return .zero
        }

        if itemSizeCalculator != nil {
            formRegisterer?.register(elementKindType: item.elementKindType, kind: item.kind, reuseIdentifier: item.reuseIdentifier, for: IndexPath(item: 0, section: section))
        }

        return item.defaultSize
            ?? itemSizeCalculator?.size(forItem: item, at: IndexPath(item: 0, section: section))
            ?? .zero
    }
    

    // MARK: UICollectionViewDataSource - configuration

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }

        return sections[section].numberOfItems
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]

        formRegisterer?.register(cellType: item.cellType, forCellReuseIdentifier: item.reuseIdentifier, for: indexPath)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)

        item.configure(cell)
        invoke(action: .configure, cell: cell, indexPath: indexPath)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let item = sections[indexPath.section].elementKindItems.first(where: { $0.kind == kind }) else {
            formRegisterer?.register(elementKindType: FormEmptyElementKindView.self, kind: kind, reuseIdentifier: FormEmptyElementKindView.reuseIdentifier, for: indexPath)
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FormEmptyElementKindView.reuseIdentifier, for: indexPath)
            return view
        }

        formRegisterer?.register(elementKindType: item.elementKindType, kind: kind, reuseIdentifier: item.reuseIdentifier, for: indexPath)

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: item.reuseIdentifier, for: indexPath)

        item.configure(view)
        invoke(action: .configure, view: view, kind: kind, indexPath: indexPath)

        return view
    }



    // MARK: UICollectionViewDataSource - Index

    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        var indexTitles = [String]()
        var indexTitlesIndexes = [Int]()
        sections.enumerated().forEach { index, section in

            if let title = section.indexTitle {
                indexTitles.append(title)
                indexTitlesIndexes.append(index)
            }
        }
        if !indexTitles.isEmpty {

            sectionsIndexTitlesIndexes = indexTitlesIndexes
            return indexTitles
        }
        sectionsIndexTitlesIndexes = nil
        return nil
    }

    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return IndexPath(item: 0, section: sectionsIndexTitlesIndexes?[index] ?? 0)
    }


    // MARK: UICollectionViewDelegate - actions

    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return invoke(action: .shouldHighlight, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? true
    }

    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        invoke(action: .didHighlight, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        invoke(action: .didUnhighlight, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return invoke(action: .shouldSelect, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? true
    }

    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return invoke(action: .shouldDeselect, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? true
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        if invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            invoke(action: .didSelect, cell: cell, indexPath: indexPath)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        invoke(action: .didDeselect, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        invoke(action: .willDisplayCell, cell: cell, indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        invoke(action: .didEndDisplayingCell, cell: cell, indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return invoke(action: .shouldBeginMultipleSelection, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? false
    }

    open func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        invoke(action: .didBeginMultipleSelection, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return invoke(action: .canMove, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? false
    }

    open func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return invoke(action: .canMoveTo, cell: collectionView.cellForItem(at: originalIndexPath), indexPath: originalIndexPath, userInfo: [FormKitUserInfoKeys.CellCanMoveProposedIndexPath: proposedIndexPath]) as? IndexPath ?? proposedIndexPath
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        invoke(action: .move, cell: collectionView.cellForItem(at: sourceIndexPath), indexPath: sourceIndexPath, userInfo: [FormKitUserInfoKeys.CellMoveDestinationIndexPath: destinationIndexPath])
    }

    @available(iOS 13.0, *)
    open func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return invoke(action: .showContextMenu, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath, userInfo: [FormKitUserInfoKeys.ContextMenuInvokePoint: point]) as? UIContextMenuConfiguration
    }

}

// MARK: - Sections manipulation

extension FormDirector {

    @discardableResult
    open func append(section: FormSection) -> Self {

        append(sections: [section])
        return self
    }

    @discardableResult
    open func append(sections: [FormSection]) -> Self {

        self.sections.append(contentsOf: sections)
        return self
    }

    @discardableResult
    open func append(items: [Item]) -> Self {

        append(section: FormSection(items: items))
        return self
    }

    @discardableResult
    open func insert(section: FormSection, atIndex index: Int) -> Self {

        sections.insert(section, at: index)
        return self
    }

    @discardableResult
    open func replaceSection(at index: Int, with section: FormSection) -> Self {

        if index < sections.count {
            sections[index] = section
        }
        return self
    }

    @discardableResult
    open func delete(sectionAt index: Int) -> Self {

        sections.remove(at: index)
        return self
    }

    @discardableResult
    open func remove(sectionAt index: Int) -> Self {
        return delete(sectionAt: index)
    }

    @discardableResult
    open func clear() -> Self {

        itemSizeCalculator?.invalidate()
        sections.removeAll()

        return self
    }
}
