//
//  main.swift
//  RunAppOnAllBootedDevices
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

let consoleIO = ConsoleIO.shared
guard CommandLine.argc == 4 else {
    consoleIO.writeMessage("Wrong arguments.", to: .error)
    consoleIO.printUsage()
    exit(9)
}
let projectName = CommandLine.arguments[1]
let appName = CommandLine.arguments[2]
let bundleID = CommandLine.arguments[3]

guard let deviceList = consoleIO.shell(launchPath: Constants.xcodePath, command: Constants.xcrun, arguments: ["simctl", "list"])?.components(separatedBy: "\n") else {
    consoleIO.writeMessage("xcrun simctl list - Failed", to: .error)
    exit(9)
}

let bootedDevices = deviceList.filter { $0.contains("(Booted)")}
print(bootedDevices)

let deviceIDs = bootedDevices.compactMap { (device) -> String in
    let components = device.components(separatedBy: CharacterSet(charactersIn: "()"))
    let uuid = components.enumerated().compactMap({ (arg) -> String? in
        if (arg.offset == 1 && !arg.element.contains("inch")) || (arg.offset == 3 && !arg.element.contains("Booted")) {
            return arg.element
        } else {
            return nil
        }
    })
    
    return String(uuid.reduce("", +))
}

let uuids = Set(deviceIDs)
print(uuids)

uuids.forEach { (uuid) in
    let path = Constants.appPath(projectName: projectName, appName: appName)
    consoleIO.writeMessage(path)
    _ = consoleIO.shellRunSimctl(arguments: ["uninstall", uuid, bundleID])
    
    _ = consoleIO.shellRunSimctl(arguments: ["install", uuid, path])
    
    _ = consoleIO.shellRunSimctl(arguments: ["launch", uuid, bundleID])
}
