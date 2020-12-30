//
//  App.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit

class App: NSObject {
    
    static let shared: App = App()
    
    let app = UIApplication.shared
}


// MARK: - Window
extension App {
    
    enum RootType {
        case mapview
    }
    
    public var delegate: AppDelegate {
        return app.delegate as! AppDelegate
    }
    
    public var window: UIWindow? {
        return delegate.window
    }
    
    private(set) var root: UIViewController? {
        set {
            window?.rootViewController = newValue
        }
        get {
            return window?.rootViewController
        }
    }
    
    public func setRoot(_ viewController: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let window = self.window else { return }
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.root = viewController
                UIView.setAnimationsEnabled(oldState)
                window.makeKeyAndVisible()
            }, completion: { (_) in
                completion?()
            })
        } else {
            root = viewController
            window.makeKeyAndVisible()
            completion?()
        }
    }
    
    public func switchRoot(type: RootType, animated: Bool = false, completion: (() -> Void)? = nil) {
        let vc = viewController(type: type)
        setRoot(vc, animated: animated, completion: completion)
    }
    
    private func viewController(type: RootType) -> UIViewController {
        switch type {
        case .mapview:
            let nav = UINavigationController(rootViewController: GeofenceAreaViewController())
            nav.setNavigationBarHidden(true, animated: false)
            return nav
        }
    }
}
