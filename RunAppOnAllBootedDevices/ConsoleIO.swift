//
//  ConsoleIO.swift
//  Panagram
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

class ConsoleIO {
    enum OutputType {
        case error
        case standard
    }
    
    static let shared: ConsoleIO = ConsoleIO()
    
    func shellRunSimctl(arguments: [String]) -> String? {
        let output = shell(launchPath: Constants.xcodePath, command: Constants.xcrun, arguments: [Constants.simctl] + arguments)
        consoleIO.writeMessage(output ?? "No output message on xcrun simctl \(arguments.reduce("", { $0 + $1 + " " }))")
        return output
    }
    
    func shell(launchPath: String,command: String, arguments: [String]) -> String? {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = [command] + arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        return output
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\u{001B}[;m\(message)")
        case .error:
            fputs("\u{001B}[0;31mError: \(message)\u{001B}\n", stderr)
        }
    }
    
    func getInput() -> String {
        let keyboard = FileHandle.standardInput
        
        let inputData = keyboard.availableData
        
        let strData = String(data: inputData, encoding: .utf8)!
        
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("\(executableName) usage:")
        writeMessage("\(executableName) <option> ... arguments ...")
        writeMessage("Options:")
        writeMessage("-h, --help:\t\t\t\tShow this help message and exit")
        writeMessage("-r, --run <build path> <app name> <bundle id>:\tInstall and run app on booted simulators")
    }
}
