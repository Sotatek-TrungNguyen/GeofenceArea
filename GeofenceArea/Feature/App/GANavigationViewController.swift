//
//  GANavigationViewController.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit

class GANavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUp() {
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Constant.Color.navigationBar
        let titleDict: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
        self.navigationBar.titleTextAttributes = titleDict
        self.navigationBar.tintColor = UIColor.white
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GANavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {

        if let currentVC = self.topViewController {
            let backImage = UIImage(named: "ic_arrow_back")?.withInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
            currentVC.navigationController?.navigationBar.backIndicatorImage = backImage
            currentVC.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            currentVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

extension UIImage {
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }
}

