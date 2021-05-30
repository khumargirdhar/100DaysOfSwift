//
//  TableViewController.swift
//  Extension
//
//  Created by Khumar Girdhar on 30/05/21.
//

import UIKit

class TableViewController: UITableViewController {
    var keys = [String]()
    var avc: ActionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpKeys()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "js")
    }
    
    func setUpKeys() {
        keys = Array(avc.savedScripts.keys).sorted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "js",for: indexPath)
        cell.textLabel?.text = keys[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        avc.script.text = avc.savedScripts[keys[indexPath.row]]
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let keyToDelete = self.keys[indexPath.row]
            self.avc.savedScripts.removeValue(forKey: keyToDelete)
            print("deleting \(keyToDelete)")
            self.setUpKeys()
            tableView.reloadData()
        }
        
        return [delete]
    }
}
