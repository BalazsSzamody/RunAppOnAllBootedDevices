//
//  StringExtension.swift
//  Panagram
//
//  Created by Balazs Szamody on 16/9/18.
//  Copyright © 2018 Balazs Szamody. All rights reserved.
//

import Foundation

extension String {
    func part(from start: Int = 0, to end: Int? = nil) -> String {
        let end: Int = end ?? self.count
        let part = self.enumerated().flatMap { (arg) -> [Character] in
            guard arg.offset >= start && arg.offset < end else {
                return []
            }
            return [arg.element]
        }
        
        return String(part)
    }
}
