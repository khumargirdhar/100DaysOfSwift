//
//  ActionViewController.swift
//  Extension
//
//  Created by Khumar Girdhar on 28/05/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var userDefaults: UserDefaults!
    var savedScripts: [String: String] = [:]
    var keyName = "customJSScript"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults = UserDefaults.standard
        savedScripts = userDefaults.dictionary(forKey: keyName) as? [String: String] ?? [:]
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        let chooseButton = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(chooseScripts))
        let loadButton = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(load))
        
        navigationItem.rightBarButtonItems = [chooseButton, saveButton, loadButton, doneButton]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, Error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        if let hostName = URL(string: self!.pageURL)?.host! {
                            let hostKey = "[autosaved from]" + hostName
                            let obj = self?.savedScripts[hostKey, default: "Enter your JavaScript code here"]
                            
                            if let scriptText = obj {
                                self?.script.text = scriptText
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func chooseScripts() {
        let ac = UIAlertController(title: "JavaScript example", message: "some example scripts", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Page title", style: .default){ [weak self] _ in
            self?.script.text = "alert(document.title);"
        })
        ac.addAction(UIAlertAction(title: "function displayTitle()", style: .default){ [weak self] _ in
            self?.script.text = """
                function displayTitle() {
                    alert(document.title);
                }
                
                displayTitle();
                """
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(ac, animated: true)
        
    }
    
    @objc func save() {
        let ac = UIAlertController(title: "Enter name of the script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default){_ in
            if let saveName = ac.textFields![0].text {
                self.savedScripts[saveName] = self.script.text
                self.userDefaults.set(self.savedScripts, forKey: self.keyName)
                self.userDefaults.set(self.script.text, forKey: saveName)
            }
        })
        
        present(ac, animated: true)
    }
    
    @objc func load() {
        
    }

}
