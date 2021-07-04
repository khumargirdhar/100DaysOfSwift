//
//  DetailViewController.swift
//  PhotosApp
//
//  Created by Khumar Girdhar on 11/05/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photos: [Photos]!
    var selectedImage: Int!
    var photo: Photos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photos != nil && selectedImage != nil else {
            navigationController?.popViewController(animated: true)
            return
        }

        photo = photos[selectedImage]
        
        title = photo.caption
        let path = Utils.getImageURL(for: photo.photo)
        imageView.image = UIImage(contentsOfFile: path.path)
        
        
//        if let imageToLoad = selectedImage?.photo {
//            print(imageToLoad)
//
//            imageView.image = UIImage(named: imageToLoad)
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
