//
//  Constants.swift
//  RunAppOnAllBootedDevices
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

struct Constants {
    static let xcodePath = "/usr/bin/env"
    static let xcrun = "xcrun"
    static func appPath(projectName: String, appName: String) -> String {
        return "~/Library/Developer/Xcode/DerivedData/\(projectName)/Build/Products/Debug-iphonesimulator/\(appName).app"
    }
}
