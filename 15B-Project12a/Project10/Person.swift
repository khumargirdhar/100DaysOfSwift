//
//  Person.swift
//  Project10
//
//  Created by Khumar Girdhar on 04/05/21.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {           //reading from disc
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {             //writing to disc
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
