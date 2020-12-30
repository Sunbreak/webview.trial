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

let html = """
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>hello</title>
  </head>
  <body>
    <script>alert('My Alert');</script>
    <div>hello, world!</div>
  </body>
</html>
"""

class WebViewController: UIViewController, WKUIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebViewController"

        let webView = view.layout(subView: WKWebView()) {
            $0.matchParent()
        }
        webView.uiDelegate = self

        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in completionHandler() })
        self.present(alertController, animated: true, completion: nil)
    }
}
