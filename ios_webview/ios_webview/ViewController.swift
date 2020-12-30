//
//  ViewController.swift
//  ios_webview
//
//  Created by sunbreak on 2020/12/29.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ViewController"
        self.view.backgroundColor = UIColor.white

        let scrollView = view.layout(subView: UIScrollView()) {
            $0.matchParent()
        }

        scrollView.layout(subView: UIStackView()) { stackView in
            stackView.matchParent()
            stackView.axis = .vertical
            self.webView = self.addArrangedButton(to: stackView, with: "WebView")
        }
    }

    var webView: UIButton!

    @objc func buttonDidClick(_ sender: UIButton) {
        switch sender {
        case webView:
            self.navigationController?.pushViewController(WebViewController(), animated: false)
        default:
            print("Unknown sender \(sender)")
        }
    }
}

extension ViewController {
    func addArrangedButton(to stackView: UIStackView, with title: String) -> UIButton {
        return stackView.arrangedLayout(subView: UIButton()) {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.alignParentLeading().alignParentTrailing()
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            $0.addTarget(self, action: #selector(self.buttonDidClick), for: .touchUpInside)
        }
    }
}

class WebViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebViewController"

        let webview = view.layout(subView: WKWebView()) {
            $0.matchParent()
        }

        webview.load(URLRequest(url: URL(string: "https://github.com")!))
    }
}
