//
//  String+Extension.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 06/02/25.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}
