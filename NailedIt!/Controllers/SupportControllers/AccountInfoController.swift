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
    private var newUserAlert: UIAlertController!
    private var checkPasswordAlert: UIAlertController!
    
}

// MARK: - Check Password Alert Related Code
extension AccountInfoController {
    
    private var passwordToCheck: String {
        return checkPasswordAlert.textFields?[0].text ?? ""
    }
    
    private func clearPasswordField() {
        // Clearing password
        self.checkPasswordAlert.textFields?[0].text = ""
    }
    
    func makeCheckPasswordAlert(forViewController viewController: UIViewController, successAction: @escaping () -> Void) {
 
        // Making a new UIAlertController every time to account for the different success actions that may be desired.
        
        checkPasswordAlert = UIAlertController(title: "Enter Password", message: "This is to keep your account safe.", preferredStyle: .alert)
        
        checkPasswordAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        
        checkPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            self.clearPasswordField()
        }))
        
        let checkPWAction = UIAlertAction(title: "Continue", style: .default, handler: { [unowned self] (action) in
            
            self.clearPasswordField()
            
            // Hitting the server to check password
            AccountManager.shared.checkPassword(username: UserSettings.current.username ?? "", passwordToCheck: self.passwordToCheck, callback: { (success) in
                
                if success {
                    successAction() // Whatever block you pass-in to trigger on success.
                } else {
                    
                    let failureAlert = UIAlertController(title: "Wrong Password", message: "Please try again! If you are still having troubles, file a support ticket.", preferredStyle: .alert)
                    failureAlert.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
                    viewController.present(failureAlert, animated: true)
                }
            })
        })
        
        checkPasswordAlert.addAction(checkPWAction)
        checkPasswordAlert.preferredAction = checkPWAction
        
        viewController.present(checkPasswordAlert, animated: true, completion: nil)
    }
}

// MARK: - New Account Related Code
extension AccountInfoController {
    
    // Computed properties based on the newUserAlert
    fileprivate var username: String {
        return newUserAlert?.textFields?[0].text ?? ""
    }
    
    fileprivate var password: String {
        return newUserAlert?.textFields?[1].text ?? ""
    }
    
    fileprivate var makeAccountButton: UIAlertAction {
        return newUserAlert.actions[1]
    }
    
    private func clearInputFields() {
        // Clearing textfields for next new user.
        for textField in self.newUserAlert.textFields! {
            textField.text = ""
        }
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
            newUserAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] (alertAction) -> Void in
                self.clearInputFields()
            }))
            let makeAccountAction = UIAlertAction(title: "Make Account", style: .default, handler: { [unowned self](alertAction) -> Void in
                
                // Making an account
                AccountManager.shared.makeAccount(username: self.newUserAlert.textFields![0].text ?? "", password: self.newUserAlert.textFields![1].text ?? "", callback: { [unowned self] (success) in
                    
                    self.clearInputFields()
                    
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
    @objc private func makeAccountInfoUpdated() {
        if username.characters.count >= USERNAME_MIN_LENGTH && password.characters.count >= PASSWORD_MIN_LENGTH {
            makeAccountButton.isEnabled = true
        } else {
            makeAccountButton.isEnabled = false
        }
    }
}
