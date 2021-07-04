//
//  ViewController.swift
//  ShoppingList
//
//  Created by Khumar Girdhar on 16/04/21.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetTapped))
        
    }
    
    @objc func resetTapped() {
        let ac = UIAlertController(title: "Clear List?", message: "Do you really want to clear the list?", preferredStyle: .alert)
        
        let reset = UIAlertAction(title: "Yes", style: .destructive) {
            [weak self, weak ac] _ in
            self?.resetList()
        }
        
        ac.addAction(reset)
        ac.addAction(UIAlertAction(title: "No", style: .default))
        present(ac,animated: true)
    }
    
    func resetList() {
    shoppingList.removeAll(keepingCapacity: true)
    tableView.reloadData()
    }
    
    @objc func addPressed() {
        let ac = UIAlertController(title: "Enter an item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitItem = UIAlertAction(title: "Submit Item", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            
            self?.submit(item)
        }
        
        ac.addAction(submitItem)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    func submit(_ item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}

