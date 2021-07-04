//
//  ViewController.swift
//  Project28
//
//  Created by Khumar Girdhar on 22/06/21.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    var passwordKey = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        self?.useFallBackAuthentication()
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func useFallBackAuthentication() {
        if hasPassword() {
            authenticateWithPassword()
        } else {
            setPassword()
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        if secret.isHidden == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Password", style: .plain, target: self, action: #selector(setPassword))
        }
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "Nothing to see here"
    }
    
    @objc func setPassword() {
        let ac = UIAlertController(title: "Set a password", message: "You can use this password to authenticate in the app.", preferredStyle: .alert)
        ac.addTextField() { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "password"
        }
        
        ac.addTextField() { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "confirm password"
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let password = self?.checkSetPassword(ac: ac!) else { return }
            
            if let passwordKey = self?.passwordKey {
                KeychainWrapper.standard.set(password, forKey: passwordKey)
            }
        }))
        
        present(ac, animated: true)
    }
    
    func checkSetPassword(ac: UIAlertController) -> String? {
        guard let password1 = getField(ac: ac, field: 0) else {
            setPasswordError(title: "Missing Password")
            return nil
        }
        
        guard let password2 = getField(ac: ac, field: 1) else {
            setPasswordError(title: "Missing Password confirmation")
            return nil
        }
        
        guard password1 == password2 else {
            setPasswordError(title: "Passwords don't match")
            return nil
        }
        
        return password1
        
    }
    
    //Challenge 2
    func getField(ac: UIAlertController?, field: Int) -> String? {
        guard let text = ac?.textFields?[field].text else {
            return nil
        }
        
        guard !text.isEmpty else { return nil }
        
        return text
    }
    
    func setPasswordError(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.setPassword()
        }))
        present(ac, animated: true)
    }
    
    func authenticateWithPassword() {
        let ac = UIAlertController(title: "Enter the password", message: nil, preferredStyle: .alert)
        
        ac.addTextField() { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "password"
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let password = self?.getField(ac: ac!, field: 0) else { return }
            
            if let passwordKey = self?.passwordKey {
                if let storedPassword = KeychainWrapper.standard.string(forKey: passwordKey) {
                    if password == storedPassword {
                        self?.unlockSecretMessage()
                        return
                    }
                }
            }
            
            let ac = UIAlertController(title: "Authentication error", message: "You could not be verified! Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }))
        
        present(ac, animated: true)
    }
    
    func hasPassword() -> Bool {
        return KeychainWrapper.standard.hasValue(forKey: passwordKey)
    }
}

