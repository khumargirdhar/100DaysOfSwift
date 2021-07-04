//
//  ViewController.swift
//  Project18
//
//  Created by Khumar Girdhar on 25/05/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print gets included in the app package.
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")           //By default terminator is \n
        
        
        
        //assert() is for only debugging time. It gets ignored by XCode when we build the app for the App Store.
        assert(1==1, "Maths failure!")          //will do nothing because condition is true
        //assert(1==2, "Maths failure!")          //This will crash the app printing Maths failure!
        
        
        for i in 0...100 {
            print("Got number - \(i)")
        }
    }       //conditional breakpoint - condition - i%10 == 0
    
    //ctrl + cmd + Y -> run the code until the next breakpoints hits.
    //exception breakpoints can be made inside breakpoint manager in the sidebar - '+' icon in the bottom left corner.
}

