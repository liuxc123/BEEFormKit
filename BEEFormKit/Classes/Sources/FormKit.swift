//
//  FormKit.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

// MARK: Common

struct FormKitNotifications {
    static let CellAction = "FormKitNotificationsCellAction"
    static let ElementKindAction = "FormKitNotificationsElementKindAction"
}

public struct FormKitUserInfoKeys {
    public static let CellMoveDestinationIndexPath = "FormKitCellMoveDestinationIndexPath"
    public static let CellCanMoveProposedIndexPath = "CellCanMoveProposedIndexPath"
    public static let ContextMenuInvokePoint = "ContextMenuInvokePoint"
}

// MARK: - Item

public protocol ItemConfigurable {

    func configure(_ cell: UICollectionViewCell)
}

public protocol ItemActionable {

    func invoke(
        action: FormItemActionType,
        cell: UICollectionViewCell?,
        path: IndexPath,
        userInfo: [AnyHashable: Any]?) -> Any?

    func has(action: FormItemActionType) -> Bool
}

public protocol ItemHashable {

    var hashValue: Int { get }
}

public protocol Item: ItemConfigurable, ItemActionable, ItemHashable {

    var reuseIdentifier: String { get }
    var cellType: AnyClass { get }

    var estimatedSize: FormItemLayoutSize { get }
    var defaultSize: CGSize? { get }
    var cacheSize: Bool { get }
}

public enum FormItemActionType {

    case configure
    case shouldHighlight
    case didHighlight
    case didUnhighlight
    case shouldSelect
    case shouldDeselect
    case click
    case didSelect
    case didDeselect
    case willDisplayCell
    case didEndDisplayingCell
    case shouldBeginMultipleSelection
    case didBeginMultipleSelection
    case canMove
    case canMoveTo
    case move
    case showContextMenu
    case custom(String)

    var key: String {

        switch (self) {
        case .custom(let key):
            return key
        default:
            return "_\(self)"
        }
    }
}

// MARK: - ElementKindItem

public protocol ElementKindItemConfigurable {

    func configure(_ view: UICollectionReusableView)
}

public protocol ElementKindItemActionable {

    func invoke(
        action: FormElementKindItemActionType,
        view: UICollectionReusableView?,
        kind: String,
        path: IndexPath,
        userInfo: [AnyHashable: Any]?) -> Any?

    func has(action: FormItemActionType) -> Bool
}

public protocol ElementKindItemHashable {

    var hashValue: Int { get }
}

public protocol ElementKindItem: ElementKindItemConfigurable, ElementKindItemHashable, ElementKindItemActionable {

    var kind: String { get set }
    var reuseIdentifier: String { get }
    var elementKindType: AnyClass { get }

    var estimatedSize: FormItemLayoutSize { get }
    var defaultSize: CGSize? { get }
    var cacheSize: Bool { get }

}

public enum FormElementKindItemActionType {

    case configure
    case custom(String)

    var key: String {

        switch (self) {
        case .custom(let key):
            return key
        default:
            return "_\(self)"
        }
    }
}


public protocol ItemSizeCalculator {

    func size(forItem item: Item, at indexPath: IndexPath) -> CGSize

    func size(forItem item: ElementKindItem, at indexPath: IndexPath) -> CGSize

    func invalidate()
}

