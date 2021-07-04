//
//  DetailViewController.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 20/05/21.
//

import UIKit

class DetailViewController: UITableViewController {
    var detailItem: countries!
    var countryName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = countryName
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "country")
        let cell = tableView.dequeueReusableCell(withIdentifier: "country",for: indexPath)
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Capital - \(detailItem!.capital)"
        case 1: cell.textLabel?.text = "Population - \(detailItem!.Population)"
        default: cell.textLabel?.text = nil
        }
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

    @objc func shareTapped() {
        var shareName: String?
        var shareCapital: String?
        var sharePopulation: String?
        
        if let name = detailItem?.name {
            shareName = "\(name) is a very beautiful country!"
        }
        if let capital = detailItem?.capital {
            shareCapital = "It's capital is \(capital)."
        }
        if let population = detailItem?.Population {
            sharePopulation = "It has a population of \(population)."
        }
//
//        let shareArray = [shareName,shareCapital,sharePopulation]
//
        
        let ac = UIActivityViewController(activityItems: [shareName, shareCapital, sharePopulation] as [Any] , applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
        present(ac, animated: true)
        
    }
}
