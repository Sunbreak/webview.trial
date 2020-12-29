//
//  NSObject+Extensions.swift
//  ios_webview
//
//  Created by sunbreak on 2020/12/30.
//

import Foundation

extension NSObjectProtocol {
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
