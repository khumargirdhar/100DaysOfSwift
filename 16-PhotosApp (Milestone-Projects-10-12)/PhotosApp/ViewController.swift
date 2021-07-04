//
//  ViewController.swift
//  PhotosApp
//
//  Created by Khumar Girdhar on 11/05/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photos]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PhotosApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
                
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "savedData") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photos].self, from: savedPhotos)
            } catch {
                print("Failed to load saved photos")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo",for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as DetailViewController? {
            vc.selectedImage = indexPath.row
            vc.photos = photos
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        
        if let jpedData = image.jpegData(compressionQuality: 0.8) {
            try? jpedData.write(to: Utils.getImageURL(for: imageName))
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Enter caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self,weak ac] _ in
            
            guard let caption = ac?.textFields?[0].text else { return }
            self?.savePicture(photo: imageName, caption: caption)
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        tableView.reloadData()
        
        
    }

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func savePicture(photo: String, caption: String) {
        let photo = Photos(photo: photo, caption: caption)
        photos.append(photo)
        
        savePictures(photos: photos)
        
        tableView.reloadData()
        
    }
    
    func savePictures(photos: [Photos]) {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData,forKey: "savedData")
        } else {
            print("Failed to save photo")
        }
        
    }

    //Swipe left to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            photos.remove(at: indexPath.row)
            
            savePictures(photos: photos)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

