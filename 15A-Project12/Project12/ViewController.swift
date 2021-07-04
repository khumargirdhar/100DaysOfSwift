//
//  ViewController.swift
//  Project12
//
//  Created by Khumar Girdhar on 09/05/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        //writing into UserDefaults
        defaults.set("Khumar Girdhar",forKey: "Name")
        defaults.set(25,forKey: "Age")
        defaults.set(CGFloat.pi,forKey: "Pi")
        defaults.set(true,forKey: "Use FaceID")
        defaults.set(Date(),forKey: "Last Run")
        
        let array = ["Hello","World"]
        defaults.set(array,forKey: "SavedArray")
        
        let dict = ["Name":"Khumar Girdhar","Country": "India"]
        defaults.set(dict,forKey: "SavedDictionary")
        
        //Reading from UserDefaults
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "Use FaceID")
        
        let savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
        
        let savedDictionary = defaults.object(forKey: "savedDictionary") as? [String: String] ?? [String: String]()
        
    }


}

