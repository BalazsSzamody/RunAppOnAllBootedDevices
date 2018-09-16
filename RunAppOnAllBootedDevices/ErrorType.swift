//
//  ErrorFactory.swift
//  Panagram
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

enum ErrorType {
    
    func throwError() {
        let consoleIO = ConsoleIO.shared
        switch self {
        default:
            consoleIO.writeMessage("Unknown Error", to: .error)
        }
    }
}
