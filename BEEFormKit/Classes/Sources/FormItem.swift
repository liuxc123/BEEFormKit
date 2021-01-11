//
//  FormItem.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

open class FormItem<CellType: ConfigurableCell>: Item where CellType: UICollectionViewCell {

    open var value: CellType.CellData
    private lazy var actions = [String: [FormItemAction<CellType>]]()

    open var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }

    open var reuseIdentifier: String {
        return CellType.reuseIdentifier
    }

    open var estimatedSize: FormItemLayoutSize {
        return CellType.estimatedSize
    }

    open var defaultSize: CGSize? {
        return CellType.defaultSize
    }

    open var cacheSize: Bool {
        return CellType.cacheSize
    }

    open var cellType: AnyClass {
        return CellType.self
    }

    public init(value: CellType.CellData, actions: [FormItemAction<CellType>]? = nil) {
        self.value = value

        /// 更新value数据事件
        let updateAction = FormItemAction<CellType>("form_item_update") { [weak self] (options) in
            if let value = options.userInfo?["value"] as? CellType.CellData {
                self?.value = value
            }
        }

        var actions = actions ?? []
        actions.append(updateAction)
        actions.forEach { on($0) }
    }

    // MARK: - ItemConfigurable -

    open func configure(_ cell: UICollectionViewCell) {
        (cell as? CellType)?.itemHashValue = hashValue
        (cell as? CellType)?.configure(with: value)
    }

    // MARK: - ItemActionable -

    open func invoke(action: FormItemActionType, cell: UICollectionViewCell?, path: IndexPath, userInfo: [AnyHashable: Any]? = nil) -> Any? {

        return actions[action.key]?.compactMap({ $0.invokeActionOn(cell: cell, value: value, path: path, userInfo: userInfo) }).last
    }

    open func has(action: FormItemActionType) -> Bool {

        return actions[action.key] != nil
    }

    // MARK: - actions -

    @discardableResult
    open func on(_ action: FormItemAction<CellType>) -> Self {

        if actions[action.type.key] == nil {
            actions[action.type.key] = [FormItemAction<CellType>]()
        }
        actions[action.type.key]?.append(action)

        return self
    }

    @discardableResult
    open func on<T>(_ type: FormItemActionType, handler: @escaping (_ options: FormItemActionOptions<CellType>) -> T) -> Self {

        return on(FormItemAction<CellType>(type, handler: handler))
    }

    @discardableResult
    open func on(_ key: String, handler: @escaping (_ options: FormItemActionOptions<CellType>) -> ()) -> Self {

        return on(FormItemAction<CellType>(.custom(key), handler: handler))
    }

    open func removeAllActions() {

        actions.removeAll()
    }

    open func removeAction(forActionId actionId: String) {

        for (key, value) in actions {
            if let actionIndex = value.firstIndex(where: { $0.id == actionId }) {
                actions[key]?.remove(at: actionIndex)
            }
        }
    }

}



