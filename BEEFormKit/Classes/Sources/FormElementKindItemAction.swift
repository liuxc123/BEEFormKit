//
//  FormElementKindItemAction.swift
//  FormKit
//
//  Created by liuxc on 2020/12/10.
//

import UIKit

open class FormElementKindItemActionOptions<ElementKindType: ConfigurableElementKind> where ElementKindType: UICollectionReusableView {

    public let value: ElementKindType.ElementKindData
    public let view: ElementKindType?
    public let kind: String
    public let indexPath: IndexPath
    public let userInfo: [AnyHashable: Any]?

    init(value: ElementKindType.ElementKindData, view: ElementKindType?, kind: String, path: IndexPath, userInfo: [AnyHashable: Any]?) {

        self.value = value
        self.view = view
        self.kind = kind
        self.indexPath = path
        self.userInfo = userInfo
    }
}

private enum FormElementKindItemActionHandler<ElementKindType: ConfigurableElementKind> where ElementKindType: UICollectionReusableView {

    case voidAction((FormElementKindItemActionOptions<ElementKindType>) -> Void)
    case action((FormElementKindItemActionOptions<ElementKindType>) -> Any?)

    func invoke(withOptions options: FormElementKindItemActionOptions<ElementKindType>) -> Any? {

        switch self {
        case .voidAction(let handler):
            return handler(options)
        case .action(let handler):
            return handler(options)
        }
    }
}

open class FormElementKindItemAction<ElementKindType: ConfigurableElementKind> where ElementKindType: UICollectionReusableView {

    open var id: String?
    public let type: FormElementKindItemActionType
    private let handler: FormElementKindItemActionHandler<ElementKindType>

    public init(_ type: FormElementKindItemActionType, handler: @escaping (_ options: FormElementKindItemActionOptions<ElementKindType>) -> Void) {

        self.type = type
        self.handler = .voidAction(handler)
    }

    public init(_ key: String, handler: @escaping (_ options: FormElementKindItemActionOptions<ElementKindType>) -> Void) {

        self.type = .custom(key)
        self.handler = .voidAction(handler)
    }

    public init<T>(_ type: FormElementKindItemActionType, handler: @escaping (_ options: FormElementKindItemActionOptions<ElementKindType>) -> T) {

        self.type = type
        self.handler = .action(handler)
    }

    public func invokeActionOn(view: UICollectionReusableView?, value: ElementKindType.ElementKindData, kind: String, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any? {

        return handler.invoke(withOptions: FormElementKindItemActionOptions(value: value, view: view as? ElementKindType, kind: kind, path: path, userInfo: userInfo))
    }
}
