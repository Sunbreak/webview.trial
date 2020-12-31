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

class WebViewController: UIViewController, WKUIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebViewController"

        let webView = view.layout(subView: WKWebView()) {
            $0.matchParent()
        }
        webView.uiDelegate = self

        webView.load(URLRequest(url: URL(string: "https://sunbreak.github.io/webview.trial/index.html")!))
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in completionHandler() })
        self.present(alertController, animated: true, completion: nil)
    }
}

let kURLProtocolHandled = "URLProtocolHandled"
let kURLLoadingNotification = "URLLoadingNotification"

class HttpURLProtocol: URLProtocol {
    static let kHttpSchema = "http"
    static let kHttpsSchema = "https"
    
    static func register() {
        let clz = NSClassFromString("WKBrowsingContextController") as! NSObject.Type
        let selector = NSSelectorFromString("registerSchemeForCustomProtocol:")
        clz.perform(selector, with: kHttpSchema)
        clz.perform(selector, with: kHttpsSchema)
        URLProtocol.registerClass(Self.self)

//        URLSessionConfiguration.default.protocolClasses?.insert(Self.self, at: 0)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        let url = request.url
        if url?.scheme == kHttpSchema || url?.scheme == kHttpsSchema {
            print("canInit(request) \(url)")
            if URLProtocol.property(forKey: kURLProtocolHandled, in: request) as? Bool ?? false {
                return false
            }
            if url?.absoluteString == "https://sunbreak.github.io/webview.trial/index.js" {
                return false
            }
        }
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        let url = task.currentRequest?.url
        if url?.scheme == kHttpSchema || url?.scheme == kHttpsSchema {
            print("canInit(task) \(url)")
            if URLProtocol.property(forKey: kURLProtocolHandled, in: task.currentRequest!) as? Bool ?? false {
                return false
            }
            if url?.absoluteString == "https://sunbreak.github.io/webview.trial/index.js" {
                return false
            }
        }
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    var dataTask: URLSessionDataTask?
    let queue = OperationQueue()
    var session: URLSession?

    override func startLoading() {
        print("startLoading")
        var request = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: kURLProtocolHandled, in: request)
        NotificationCenter.default .post(name: Notification.Name(rawValue: kURLLoadingNotification), object: request.url?.absoluteString)

        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: self.queue)
        self.dataTask = self.session?.dataTask(with: request as URLRequest)
        self.dataTask?.resume()
    }

    override func stopLoading() {
        print("stopLoading")
        self.session?.invalidateAndCancel()
        self.session = nil
        NotificationCenter.default.post(name: Notification.Name(rawValue: kURLLoadingNotification), object: "")
    }
}

extension HttpURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("urlSession:task:willPerformHTTPRedirection:newRequest:completionHandler \(task) \(response) \(request)")
        var newRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.removeProperty(forKey: kURLProtocolHandled, in: newRequest)
        self.client?.urlProtocol(self, wasRedirectedTo: newRequest as URLRequest, redirectResponse: response)

        self.dataTask?.cancel()
        self.client?.urlProtocol(self, didFailWithError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("urlSession:task:didCompleteWithError \(task) \(error)")
        if (error != nil) {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("urlSession:dataTask:didReceive:completionHandler \(dataTask) \(response)")
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("urlSession:dataTask:didReceive \(dataTask) \(data)")
        self.client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("urlSession:dataTask:willCacheResponse:completionHandler \(dataTask) \(proposedResponse)")
        completionHandler(proposedResponse)
    }
}
