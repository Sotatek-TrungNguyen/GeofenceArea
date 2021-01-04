//
//  String+Extensions.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 1/4/21.
//  Copyright © 2021 Nguyen Thanh Trung. All rights reserved.
//

import Foundation

extension String {
    public func trimSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
