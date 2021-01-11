//
//  FormItemAction.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

open class FormItemActionOptions<CellType: ConfigurableCell> where CellType: UICollectionViewCell {

    public let value: CellType.CellData
    public let cell: CellType?
    public let indexPath: IndexPath
    public let userInfo: [AnyHashable: Any]?

    init(value: CellType.CellData, cell: CellType?, path: IndexPath, userInfo: [AnyHashable: Any]?) {

        self.value = value
        self.cell = cell
        self.indexPath = path
        self.userInfo = userInfo
    }
}

private enum FormItemActionHandler<CellType: ConfigurableCell> where CellType: UICollectionViewCell {

    case voidAction((FormItemActionOptions<CellType>) -> Void)
    case action((FormItemActionOptions<CellType>) -> Any?)

    func invoke(withOptions options: FormItemActionOptions<CellType>) -> Any? {

        switch self {
        case .voidAction(let handler):
            return handler(options)
        case .action(let handler):
            return handler(options)
        }
    }
}

open class FormItemAction<CellType: ConfigurableCell> where CellType: UICollectionViewCell {

    open var id: String?
    public let type: FormItemActionType
    private let handler: FormItemActionHandler<CellType>

    public init(_ type: FormItemActionType, handler: @escaping (_ options: FormItemActionOptions<CellType>) -> Void) {

        self.type = type
        self.handler = .voidAction(handler)
    }

    public init(_ key: String, handler: @escaping (_ options: FormItemActionOptions<CellType>) -> Void) {

        self.type = .custom(key)
        self.handler = .voidAction(handler)
    }

    public init<T>(_ type: FormItemActionType, handler: @escaping (_ options: FormItemActionOptions<CellType>) -> T) {

        self.type = type
        self.handler = .action(handler)
    }

    public func invokeActionOn(cell: UICollectionViewCell?, value: CellType.CellData, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any? {

        return handler.invoke(withOptions: FormItemActionOptions(value: value, cell: cell as? CellType, path: path, userInfo: userInfo))
    }
}
