//
//  main.swift
//  RunAppOnAllBootedDevices
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

let consoleIO = ConsoleIO.shared
let option = OptionType(CommandLine.arguments[1])
let mode = Mode(option)
mode.runCurrentMode()


