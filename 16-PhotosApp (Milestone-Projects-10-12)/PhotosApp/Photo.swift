//
//  Photo.swift
//  PhotosApp
//
//  Created by Khumar Girdhar on 11/05/21.
//

import Foundation

class Photos: Codable {
    var photo: String
    var caption: String
    
    init(photo: String,caption: String) {
        self.photo = photo
        self.caption = caption
    }
}
