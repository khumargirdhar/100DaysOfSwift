//
//  Note.swift
//  Notes
//
//  Created by Khumar Girdhar on 04/06/21.
//

import Foundation

class Note: Codable {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
