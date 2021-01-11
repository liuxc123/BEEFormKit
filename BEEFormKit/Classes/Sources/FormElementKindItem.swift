//
//  FormElementKindSection.swift
//  FormKit
//
//  Created by liuxc on 2020/12/10.
//

import UIKit

open class FormElementKindItem<ElementKindType: ConfigurableElementKind>: ElementKindItem where ElementKindType: UICollectionReusableView {

    open var value: ElementKindType.ElementKindData
    public var kind: String
    private lazy var actions = [String: [FormElementKindItemAction<ElementKindType>]]()

    open var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }

    open var reuseIdentifier: String {
        return ElementKindType.reuseIdentifier
    }

    open var defaultSize: CGSize? {
        return ElementKindType.defaultSize
    }

    open var estimatedSize: FormItemLayoutSize {
        return ElementKindType.estimatedSize
    }

    open var cacheSize: Bool {
        return ElementKindType.cacheSize
    }

    open var elementKindType: AnyClass {
        return ElementKindType.self
    }

    public init(kind: String, value: ElementKindType.ElementKindData, actions: [FormElementKindItemAction<ElementKindType>]? = nil) {

        self.kind = kind
        self.value = value

        /// 更新value数据事件
        let updateAction = FormElementKindItemAction<ElementKindType>("form_kind_item_update") { [weak self] (options) in
            if let value = options.userInfo?["value"] as? ElementKindType.ElementKindData {
                self?.value = value
            }
        }

        var actions = actions ?? []
        actions.append(updateAction)
        actions.forEach { on($0) }
    }

    // MARK: - ElementKindItemConfigurable -

    public func configure(_ view: UICollectionReusableView) {
        (view as? ElementKindType)?.itemHashValue = hashValue
        (view as? ElementKindType)?.configure(with: value)
    }

    // MARK: - ElementKindItemActionable -

    public func invoke(action: FormElementKindItemActionType, view: UICollectionReusableView?, kind: String, path: IndexPath, userInfo: [AnyHashable : Any]?) -> Any? {

        return actions[action.key]?.compactMap({ $0.invokeActionOn(view: view, value: value, kind: kind, path: path, userInfo: userInfo) }).last
    }

    public func has(action: FormItemActionType) -> Bool {

        return actions[action.key] != nil
    }

    // MARK: - actions -

    @discardableResult
    open func on(_ action: FormElementKindItemAction<ElementKindType>) -> Self {

        if actions[action.type.key] == nil {
            actions[action.type.key] = [FormElementKindItemAction<ElementKindType>]()
        }
        actions[action.type.key]?.append(action)

        return self
    }

    @discardableResult
    open func on<T>(_ type: FormElementKindItemActionType, handler: @escaping (_ options: FormElementKindItemActionOptions<ElementKindType>) -> T) -> Self {

        return on(FormElementKindItemAction<ElementKindType>(type, handler: handler))
    }

    @discardableResult
    open func on(_ key: String, handler: @escaping (_ options: FormElementKindItemActionOptions<ElementKindType>) -> ()) -> Self {

        return on(FormElementKindItemAction<ElementKindType>(.custom(key), handler: handler))
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
