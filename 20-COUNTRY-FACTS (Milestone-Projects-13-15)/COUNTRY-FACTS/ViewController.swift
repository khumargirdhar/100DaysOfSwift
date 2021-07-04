//
//  ViewController.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 20/05/21.
//

import UIKit

class ViewController: UITableViewController {
    var Countries = [countries]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country-Facts!"
        navigationController?.navigationBar.prefersLargeTitles = true

        if let data = loadJSON(filename: "countries") {
            Countries = data
        } else {
            print("failed to load countries data")
        }
        
        print(Countries)
        
    }
    
    func loadJSON(filename fileName: String) -> [countries]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Country.self, from: data)
                return jsonData.results
            } catch {
                print("error: \(error)")
            }
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country",for: indexPath)
        let country = Countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = Countries[indexPath.row]
        vc.countryName = Countries[indexPath.row].name.uppercased()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

