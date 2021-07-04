//
//  Utils.swift
//  PhotosApp
//
//  Created by Khumar Girdhar on 11/05/21.
//

import Foundation

class Utils {
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func getImageURL(for imageName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(imageName)
    }
    
}

