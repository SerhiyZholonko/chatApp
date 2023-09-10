//
//  String.swift
//  chatApp
//
//  Created by apple on 10.09.2023.
//

import Foundation

extension String {
    func firstWord() -> String? {
        let words = self.components(separatedBy: " ")
        return words.first
    }
}
