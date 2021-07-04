//
//  ViewController.swift
//  Project7
//
//  Created by Khumar Girdhar on 17/04/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector((creditsTapped)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        performSelector(onMainThread: #selector(fetchJSON), with: self, waitUntilDone: false)
    }

    @objc func fetchJSON() {
        let urlString: String
        
            if navigationController?.tabBarItem.tag == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
        

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    //we're OK to parse
                    parse(json: data)
                    filteredPetitions = petitions
                    return
                }
            }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    
    @objc func showError() {
            let ac = UIAlertController(title: "loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac,animated: true)
        }
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }
            
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true )
    }

    @objc func creditsTapped() {
        let ac = UIAlertController(title: "This data comes from We The People API of the white house.", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterTapped() {
            let ac = UIAlertController(title: "Enter filter", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let action = UIAlertAction(title: "Search", style: .default) {
                [weak self,weak ac] _ in
                guard let filteredItem = ac?.textFields?[0].text else { return }
                self?.submit(filteredItem)
            }
            
            ac.addAction(action)
            present(ac, animated: true)
        }

    
    @objc func submit(_ filteredItem: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.filteredPetitions.removeAll(keepingCapacity: true)
            for i in self!.petitions {
                if i.title.contains(filteredItem) {
                    self?.filteredPetitions.append(i)
                    }
                }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

