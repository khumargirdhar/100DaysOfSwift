//
//  DetailViewController.swift
//  Notes
//
//  Created by Khumar Girdhar on 04/06/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var NoteView: UITextView!
    var currentNote: Note?
    var newNote: String?
    var noteBody = ""
    var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentNote?.title ?? ""
        NoteView.text = noteBody
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: delegate, action: #selector(delegate.deleteNoteTapped))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTapped))
        
        navigationItem.rightBarButtonItems = [deleteButton, shareButton, saveButton]
        
    }
    
    
    @objc func shareTapped() {
        let text = NoteView.text
        let obj = [text]
        let ac = UIActivityViewController(activityItems: obj as [Any], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func saveTapped() {
        let noteArr = NoteView.text.split(separator: "\n")
        let noteTitle = String(noteArr[0])
        
        delegate.updateTitle(title: noteTitle)
        delegate.updateBody(body: noteBody)
        delegate.save()
        delegate.tableView.reloadData()
        self.viewDidLoad()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.viewDidLoad()
    }
}
