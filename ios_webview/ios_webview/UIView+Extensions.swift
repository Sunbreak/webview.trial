//
//  UIView+Extensions.swift
//  ios_webview
//
//  Created by sunbreak on 2020/12/30.
//

import UIKit

extension UIView {
    @discardableResult
    func layout<E: UIView>(subView: E, closure: ((E) -> Void)? = nil) -> E {
        self.addSubview(subView)
        closure?(subView)
        return subView
    }

    @discardableResult
    func alignParentLeading() -> Self {
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor).isActive = true
        return self
    }

    @discardableResult
    func alignParentTrailing() -> Self {
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor).isActive = true
        return self
    }

    @discardableResult
    func alignParentTop(_ systemSpace: Bool = false) -> Self {
        if systemSpace {
            self.topAnchor.constraint(equalToSystemSpacingBelow: self.superview!.topAnchor, multiplier: 1).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor).isActive = true
        }
        return self
    }

    @discardableResult
    func alignParentBottom() -> Self {
        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor).isActive = true
        return self
    }

    @discardableResult
    func matchParent() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return alignParentLeading().alignParentTrailing().alignParentTop().alignParentBottom()
    }
}

extension UIStackView {
    @discardableResult
    func arrangedLayout<E: UIView>(subView: E, closure: ((E) -> Void)? = nil) -> E {
        self.addArrangedSubview(subView)
        closure?(subView)
        return subView
    }
}
