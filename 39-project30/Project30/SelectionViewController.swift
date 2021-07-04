//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    
    var images: [UIImage?] = [UIImage]()
    var finishedLoadingImages = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        //Challenge 3
        DispatchQueue.global().async { [weak self] in
            self?.loadImages()
        }
    }
    
    //Challenge 3
    func loadImages() {
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        //Challenge 1
        guard let path = Bundle.main.resourcePath else { return }

        if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                    
                    //Try to load from cache
                    if let image = saveToCache(name: item) {
                        images.append(image)
                    }
                    //or create and save to cache
                    else {
                        images.append(createThumbnails(currentImage: item))
                    }
                }
            }
        }
        
        finishedLoadingImages = true
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    //Challenge 3
    func saveToCache(name: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: path.path)
    }
    
    //Challenge 3
    func saveToCache(name: String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
    }
    
    //Challenge 3
    func createThumbnails(currentImage: String) -> UIImage? {
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        
        //Challenge 1
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else {
            fatalError("Could'nt find path of imageRootName")
        }
        guard let original = UIImage(contentsOfFile: path) else { fatalError("Could'nt find the image at the path specified - \(path) ") }

        //Scaling down the image to 90x90 rect
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()

            original.draw(in: renderRect)
        }

        saveToCache(name: currentImage, image: rounded)
        return rounded
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Challenge 3
        if !finishedLoadingImages {
            return 0
        }
        
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
        let index = indexPath.row % items.count
        cell.imageView?.image = images[index]
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: items[index]))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		navigationController!.pushViewController(vc, animated: true)
	}
    
    //Challenge 3
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
