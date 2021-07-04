//
//  ViewController.swift
//  Project10
//
//  Created by Khumar Girdhar on 03/05/21.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    //Project 28 - Challenge 3
    var hiddenPeople = [Person]()
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlock", style: .done, target: self, action: #selector(unlockTapped))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let JSONDecoder = JSONDecoder()
            
            do {
                //Project 28 - Challenge 3
                hiddenPeople = try JSONDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.,")
            }
        }
        collectionView.reloadData()
        
        //Project 28 - Challenge 3
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lock), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    //Project 28 - Challenge 3
    @objc func unlockTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlock()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed.", message: "You could not be verified! Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global().async { [weak self] in
            guard let image = info[.editedImage] as? UIImage else { return }
            
            let imageName = UUID().uuidString
            let imagePath = self?.getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                if let imagePath = imagePath {
                    try? jpegData.write(to: imagePath)
                }
            }
            
            let person = Person(name: "unknown", image: imageName)
            self?.people.append(person)
            self?.save()
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.dismiss(animated: true)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac1 = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        
        ac1.addAction(UIAlertAction(title: "Rename Person", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self,weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.save()
                self?.collectionView.reloadData()
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac,animated: true)
        })
        
        ac1.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            collectionView.reloadData()
        })
        
        present(ac1, animated: true)
    }
    
    func save() {
        let JSONEncoder = JSONEncoder()
        
        if let savedData = try? JSONEncoder.encode(people) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData,forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
    func unlock() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        people = hiddenPeople
        collectionView.reloadData()
    }
    
    @objc func lock() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem?.isEnabled = true
        save()
        people = [Person]()
        collectionView.reloadData()
    }
}

