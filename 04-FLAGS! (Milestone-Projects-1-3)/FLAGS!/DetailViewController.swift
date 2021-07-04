//
//  DetailViewController.swift
//  FLAGS!
//
//  Created by Khumar Girdhar on 07/04/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage?.uppercased()
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }

    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        let vc = UIActivityViewController(activityItems: [image,"\(selectedImage!)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
}
