//
//  FormCellAction.swift
//  FormKit
//
//  Created by liuxc on 2020/12/9.
//

import UIKit

/**
    A custom action that you can trigger from your cell.
    You can easily catch actions using a chaining manner with your row.
*/
open class FormCellAction {

    /// The cell that triggers an action.
    public let cell: UICollectionViewCell

    /// The action unique key.
    public let key: String

    /// The custom user info.
    public let userInfo: [AnyHashable: Any]?

    public init(key: String, sender: UICollectionViewCell, userInfo: [AnyHashable: Any]? = nil) {

        self.key = key
        self.cell = sender
        self.userInfo = userInfo
    }

    public init(sender: UICollectionViewCell, value: Any) {
        self.key = "form_item_update"
        self.cell = sender
        self.userInfo = ["value": value]
    }

    open func invoke() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: FormKitNotifications.CellAction), object: self, userInfo: userInfo)
    }
}

