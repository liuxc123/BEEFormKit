//
//  FormElementKindViewAction.swift
//  FormKit
//
//  Created by liuxc on 2020/12/10.
//

import UIKit

/**
    A custom action that you can trigger from your cell.
    You can easily catch actions using a chaining manner with your row.
*/
open class FormElementKindViewAction {

    /// The cell that triggers an action.
    public let view: UICollectionReusableView

    /// The action unique key.
    public let key: String

    public let hashValue: Int

    /// The custom user info.
    public let userInfo: [AnyHashable: Any]?

    public init(key: String, sender: UICollectionReusableView, hashValue: Int, userInfo: [AnyHashable: Any]? = nil) {

        self.key = key
        self.view = sender
        self.hashValue = hashValue
        self.userInfo = userInfo
    }

    public init(sender: UICollectionReusableView, hashValue: Int, value: Any) {

        self.key = "form_kind_item_update"
        self.view = sender
        self.hashValue = hashValue
        self.userInfo = ["value": value]
    }

    open func invoke() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: FormKitNotifications.ElementKindAction), object: self, userInfo: userInfo)
    }
}
