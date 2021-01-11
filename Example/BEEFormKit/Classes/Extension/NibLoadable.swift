//
//  NibLoadable.swift
//  FormKit_Example
//
//  Created by liuxc on 2020/12/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// 协议
protocol NibLoadable: class {

}

// 加载nib
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
