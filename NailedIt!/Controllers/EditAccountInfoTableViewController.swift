//
//  EditAccountInfoTableViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-10-08.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

// Some constants and tags
private let USERNAME_TEXT_FIELD_TAG = 5000
private let PASSWORD_TEXT_FIELD_TAG = 5001
private let PASSWORD_MAX_LENGTH = 16
private let USERNAME_MAX_LENGTH = 16
private let USERNAME_MIN_LENGTH = UserSettings.USERNAME_MIN_LENGTH
private let PASSWORD_MIN_LENGTH = UserSettings.PASSWORD_MIN_LENGTH

class EditAccountInfoTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.tag = USERNAME_TEXT_FIELD_TAG
        passwordTextField.tag = PASSWORD_TEXT_FIELD_TAG
        
        // NOTE: The null coalescing operators here are for debugging output before login
        // networking code is complete. It should be replaced with a forced unwrap after.
        userNameTextField.placeholder = UserSettings.current.username ?? "None"
        passwordTextField.placeholder = UserSettings.current.password ?? "None"
    
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(fieldsEdited), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(fieldsEdited), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Do some networking here to update account info
        
        let newUserName = userNameTextField.text
        let newPassword = passwordTextField.text
        
        AccountManager.shared.updateAccount(username: newUserName, password: newPassword, callback: { [unowned self] (success) in
            if success {
                
                // Popping an alert to let the user know saving succeeded
                let successAlert = UIAlertController(title: "Info Updated!", message: "Your account information was successfully changed.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "Return", style: .default, handler: { [unowned self] _ in
                    
                    // Going back to settings page.
                    self.navigationController?.popViewController(animated: true)
                }))
                
                // Changing user defaults store
                UserSettings.current.username = newUserName
                UserSettings.current.password = newPassword
                
                self.present(successAlert, animated: true)
            } else {
                // Error reporting here
            }
        })
    }
    
    @objc private func fieldsEdited() {
        
        // Evaluating if saving should be enabled.
        // If only one is empty and the other fulfills the length requirements of its field, allows saving
        // If both fulfill length requirements of their fields, allows saving
        // Disallows otherwise (so if both are empty / unedited, disallow saving).
        if ((passwordTextField.text ?? "" == "") || ((passwordTextField.text!).count >= PASSWORD_MIN_LENGTH)) &&
            ((userNameTextField.text ?? "" == "") || ((userNameTextField.text ?? "").count >= USERNAME_MIN_LENGTH)) &&
            !((userNameTextField.text ?? "" == "") && (passwordTextField.text ?? "" == "")) {
            
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
}

// MARK: - UITextFieldDelegate Methods
extension EditAccountInfoTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // The new state of the text if the change happens
        let newText = (textField.text ?? "") + string
        
        // Allowing the change if the text is under or at our limit, and cutting it if it isn't
        if newText.count <= (textField.tag == USERNAME_TEXT_FIELD_TAG ? USERNAME_MAX_LENGTH : PASSWORD_MAX_LENGTH) {
            return true
        } else {
            
            // This runs if newText.count > Constants.commentsMaxLength
            
            // Then, we're cutting off the string at index: Constants.commentsMaxLength,
            // since strings start indexing at zero, this will give us our proper string.
            textField.text = String(newText[..<newText.index(newText.startIndex, offsetBy: (textField.tag == USERNAME_TEXT_FIELD_TAG ? USERNAME_MAX_LENGTH : PASSWORD_MAX_LENGTH))])
            
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}













