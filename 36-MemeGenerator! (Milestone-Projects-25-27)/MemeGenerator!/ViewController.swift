//
//  ViewController.swift
//  MemeGenerator!
//
//  Created by Khumar Girdhar on 20/06/21.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var topString = ""
    var bottomString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MemeGenerator!"
        
        let importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.rightBarButtonItems = [importButton, shareButton]
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] else { return }
        imageView.image = image as? UIImage
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Enter text", message: "if any", preferredStyle: .alert)
            ac.addTextField { (textField) in
                textField.placeholder = "Top text"
            }
            
            ac.addTextField { (textField) in
                textField.placeholder = "Bottom text"
            }
            
            ac.addAction(UIAlertAction(title: "DONE", style: .default, handler: { [weak self] (UIAlertAction) in
                self?.topString = ac.textFields![0].text ?? ""
                self?.bottomString = ac.textFields![1].text ?? ""
                self?.imageView.image = self?.editImage()
            }))
            self.present(ac, animated: true)
        }
        
    }

    func editImage() -> UIImage {
        
        guard let image = imageView.image else {
            print("No image found!")
            return UIImage()
        }
        
        guard let imageSize = imageView.image?.size else { return image }
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let newImage = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 150),
                .paragraphStyle: paragraphStyle,
                .strokeWidth: -5,
                .strokeColor: UIColor.black,
                .foregroundColor: UIColor.white
            ]

            for i in 0...1 {
                var textToPlace = ""
                var textRect = CGRect()
                
                if i==0 {
                    textRect = CGRect(x: 20, y: 70, width: imageSize.width - 40, height: imageSize.height - 64)
                    
                    textToPlace = topString
                } else {
                    textRect = CGRect(x: 20, y: (imageSize.height - 200), width: imageSize.width - 40 , height: imageSize.height - ((imageSize.height - 325)))
                    
                    textToPlace = bottomString
                }
                
                let text = NSAttributedString(string: textToPlace.uppercased(), attributes: attrs)
                text.draw(with: textRect, options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        return newImage
    }
    
    @objc func shareTapped() {
        guard imageView.image != nil else { return }
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}

