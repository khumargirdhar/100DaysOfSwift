//
//  ViewController.swift
//  Notes
//
//  Created by Khumar Girdhar on 04/06/21.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    var noteIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeTapped))
        
        performSelector(inBackground: #selector(loadNotes), with: nil)
        
    }
    
    @objc func loadNotes() {
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "savedNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes.")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = CGFloat(70)
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title + "\n" + notes[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        noteIndex = indexPath.row
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            vc.noteBody = note.body
            vc.delegate = self
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func composeTapped() {
        
        var newNote = Note(title: "", body: "")
        notes.insert(newNote, at: 0)
        save()
        tableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateTitle(title: String) {
        notes[noteIndex].title = title
        tableView.reloadData()
    }
    
    func updateBody(body: String) {
        notes[noteIndex].body = body
        tableView.reloadData()
    }
    
    @objc func deleteNoteTapped() {
        notes.remove(at: noteIndex)
        save()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedNotes = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedNotes, forKey: "savedNotes")
        } else {
            print("Failed to save notes.")
        }
        
    }
}

