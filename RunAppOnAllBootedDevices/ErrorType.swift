//
//  ErrorFactory.swift
//  Panagram
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

enum ErrorType: Error {
    case wrongArgument
    case unknown(message: String)
    
    var localizedDescription: String {
        switch self {
        case .wrongArgument:
            return "Wrong arguments"
        case .unknown(message: let message):
            return message
        }
    }
    
    func throwError() {
        let consoleIO = ConsoleIO.shared
        consoleIO.writeMessage(self.localizedDescription, to: .error)
        consoleIO.printUsage()
        fatalError()
    }
}
