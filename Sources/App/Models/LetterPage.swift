//
//  LetterPage.swift
//  App
//
//  Created by tigeriv on 10/30/18.
//

import Foundation

final class LetterPage: Codable {
    let letterTitle: String?
    let children: [String]?
    let ocrText: String?
    let numPages: Int
    let metadata: docArray?
    let pid: String?

    init (title: String?, children: [String]?, ocrText: String?, numPages: Int?, metadata: docArray?, pid: String?)
    {
        self.letterTitle = title
        self.children = children
        self.ocrText = ocrText
        self.numPages = numPages ?? 0
        self.metadata = metadata
        self.pid = pid
    }
}
