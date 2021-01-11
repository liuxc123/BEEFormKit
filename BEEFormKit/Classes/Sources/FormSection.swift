//
//  FormSection.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

open class FormSection {

    open private(set) var items = [Item]()
    open private(set) var elementKindItems = [ElementKindItem]()

    open var headerTitle: String?
    open var footerTitle: String?
    open var indexTitle: String?

    open var numberOfItems: Int {
        return items.count
    }

    open var isEmpty: Bool {
        return items.isEmpty
    }

    public init(items: [Item]? = nil, elementKindItems: [ElementKindItem]? = nil) {

        if let initialItems = items {
            self.items.append(contentsOf: initialItems)
        }

        if let initialElementKindItems = elementKindItems {
            self.elementKindItems.append(contentsOf: initialElementKindItems)
        }
    }

    // MARK: - Public -

    open func clear() {
        items.removeAll()
    }

    open func append(item: Item) {
        append(items: [item])
    }

    open func append(items: [Item]) {
        self.items.append(contentsOf: items)
    }

    open func insert(item: Item, at index: Int) {
        items.insert(item, at: index)
    }

    open func insert(items: [Item], at index: Int) {
        self.items.insert(contentsOf: items, at: index)
    }

    open func replace(itemAt index: Int, with item: Item) {
        items[index] = item
    }

    open func swap(from: Int, to: Int) {
        items.swapAt(from, to)
    }

    open func delete(itemAt index: Int) {
        items.remove(at: index)
    }

    open func remove(itemAt index: Int) {
        items.remove(at: index)
    }

}

