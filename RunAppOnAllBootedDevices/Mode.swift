//
//  Mode.swift
//  RunAppOnAllBootedDevices
//
//  Created by Balazs Szamody on 17/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

enum OptionType {
    case run
    case help
    case unknown
    
    init(_ input: String) {
        switch input {
        case "-r", "--run":
            self = .run
        case "-h", "--help":
            self = .help
        default:
            self = .unknown
        }
    }
    
    var argCount: Int {
        switch self {
        case .run:
            return 5
        case .help:
            return 2
        default:
            return 0
        }
    }
}

class Mode {
    
    let mode: OptionType
    
    init(_ option: OptionType) {
        self.mode = option
    }
    
    func runCurrentMode() {
        guard CommandLine.argc == mode.argCount else {
            ErrorType.wrongArgument.throwError()
            return
        }
        switch mode {
        case .run:
            runApp()
        case .help:
            consoleIO.printUsage()
            exit(0)
        case .unknown:
            ErrorType.wrongArgument.throwError()
        }
    }
    
    private func runApp() {
        
        let buildPath = CommandLine.arguments[2]
        let appName = CommandLine.arguments[3]
        let bundleID = CommandLine.arguments[4]
        
        guard let deviceList = consoleIO.shellRunSimctl(arguments: ["list"])?.components(separatedBy: "\n") else {
            consoleIO.writeMessage("xcrun simctl list - Failed", to: .error)
            exit(10)
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
            let path = buildPath + appName
            consoleIO.writeMessage(path)
            _ = consoleIO.shellRunSimctl(arguments: ["uninstall", uuid, bundleID])
            
            _ = consoleIO.shellRunSimctl(arguments: ["install", uuid, path])
            
            _ = consoleIO.shellRunSimctl(arguments: ["launch", uuid, bundleID])
        }
    }
    
}
