//
//  AccountInfoController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-10-08.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import Foundation
import UIKit

// Some constants
private let PASSWORD_MIN_LENGTH = UserSettings.PASSWORD_MIN_LENGTH
private let USERNAME_MIN_LENGTH = UserSettings.USERNAME_MIN_LENGTH

class AccountInfoController {
    
    static let shared = AccountInfoController()
    private init() {}
    var newUserAlert: UIAlertController!
    var checkPasswordAlert: UIAlertController!
    
    // Computed properties based on the newUserAlert
    var username: String {
        return newUserAlert?.textFields?[0].text ?? ""
    }
    
    var password: String {
        return newUserAlert?.textFields?[1].text ?? ""
    }
    
    var makeAccountButton: UIAlertAction {
        return newUserAlert.actions[1]
    }
    
    func makeCheckPasswordAlert(forViewController viewController: UIViewController) {
        if checkPasswordAlert == nil {
            
            
            
        }
        
        viewController.present(checkPasswordAlert, animated: true, completion: nil)
    }
    
    func makeNewUserAlert(forViewController viewController: UIViewController) {
    
        // Presenting new user entry.
        if newUserAlert == nil {
            
            // Setting up the make account alert
            newUserAlert = UIAlertController(title: "New User", message: "Please choose your username and password.", preferredStyle: .alert)
            
            // Adding username/password textfields
            newUserAlert.addTextField(configurationHandler: { [unowned self] (textField) in
                textField.placeholder = "Username: Must be > 4 characters"
                textField.addTarget(self, action: #selector(self.makeAccountInfoUpdated), for: .editingChanged)
            })
            newUserAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Password: Must be > 5 characters"
                textField.isSecureTextEntry = true
                textField.addTarget(self, action: #selector(self.makeAccountInfoUpdated), for: .editingChanged)
            })
            
            // Adding UIAlertActions
            newUserAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let makeAccountAction = UIAlertAction(title: "Make Account", style: .default, handler: { [unowned self](alertAction) -> Void in
                
                // Making an account
                AccountManager.shared.makeAccount(username: self.newUserAlert.textFields![0].text ?? "", password: self.newUserAlert.textFields![1].text ?? "", callback: { [unowned self] (success) in
                    
                    // Clearing textfields for next new user.
                    for textField in self.newUserAlert.textFields! {
                        textField.text = ""
                    }
                    
                    // Handling the response from the server.
                    if success {
                        let successAlert = UIAlertController(title: "Account Made!" , message: "Congratulations, you are now registered for Nailed It!", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Cool!", style: .default, handler: nil))
                        // Maybe add auto-login code here?
                        viewController.present(successAlert, animated: true)
                    } else {
                        let errorAlert = UIAlertController(title: "Uh Oh..", message: "Sorry, something went wrong on our side. Please try again in a bit.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        viewController.present(errorAlert, animated: true)
                    }
                })
            })
            
            newUserAlert.addAction(makeAccountAction)
            newUserAlert.preferredAction = makeAccountAction
        }
        
        viewController.present(newUserAlert, animated: true)
    }
    
    /// Function to change status of make account button based on textfield edits.
    /// - Note: Receives updates from target-action mechanism.
    @objc func makeAccountInfoUpdated() {
        if username.characters.count >= USERNAME_MIN_LENGTH && password.characters.count >= PASSWORD_MIN_LENGTH {
            makeAccountButton.isEnabled = true
        } else {
            makeAccountButton.isEnabled = false
        }
    }
    
}
