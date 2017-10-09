//
//  LoginViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-09-08.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

private let PASSWORD_MIN_LENGTH = UserSettings.PASSWORD_MIN_LENGTH
private let USERNAME_MIN_LENGTH = UserSettings.USERNAME_MIN_LENGTH

class LoginViewController: UIViewController {

    // MARK: - Outlets and Storyboard Properties
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    // Controller / Programmatically Generated UI Elements
    var newUserEntry: UIAlertController!
    
    // MARK: - Constants
    let GREYED_OUT_OPACITY: Float = 0.7
    
    // MARK: - Computed Storyboard Properties
    
    // Effectively doing textfield.text == nil : "" ? textfield.text so as not to deal with optionals.
    
    var username: String {
        return usernameTextField.text ?? ""
    }
    
    var password: String {
        return passwordTextField.text ?? ""
    }
    
    
    // MARK: - UIViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populating the version label
        versionLabel.text = "v.\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
        
        // View Setup
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 5.0
        loginButton.isEnabled = false
        loginButton.layer.opacity = GREYED_OUT_OPACITY
        
        // Adding recognizers
        addListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Listener / Target-Action / Recognizer
    
    /// Private function to be called once on viewDidLoad to set-up any relevant recognizers and targets. 
    /// - Important: Only call once per view controller lifecycle.
    private func addListeners() {
        
        let cancelRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(cancelRecognizer)
        usernameTextField.addTarget(self, action: #selector(loginInfoUpdated), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(loginInfoUpdated), for: .editingChanged)
    }
    
    /// Function to change status of login button based on textfield edits.
    /// - Note: Receives updates from target-action mechanism.
    @objc func loginInfoUpdated() {
        if username.characters.count >= USERNAME_MIN_LENGTH && password.characters.count >= PASSWORD_MIN_LENGTH {
            loginButton.isEnabled = true
            loginButton.layer.opacity = 1.0
        } else {
            loginButton.isEnabled = false
            loginButton.layer.opacity = GREYED_OUT_OPACITY
        }
    }

    /// Ends any editing actions currently taking place.
    /// - Important: Dismisses keyboard as a side effect.
    // Add to this function as editable elements increase. 
    // If too many, can use subviews for loops and "is" operator to filter.
    @objc func endEditing() {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    /// Clears the username and password, to be called when leaving the screen or when otherwise needed.
    func clearTextFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        /*
        AccountManager.shared.performLogin(username: username, password: password, callback: { (success: Bool) in
            if success {
                print("Succeeded!")
         
                 // Saving in user settings
                 UserSettings.current.username = username
                 UserSettings.current.password = password
            } else {
                print("Failed :(")
            }})
        */
        
        guard let challengeEntryController = storyboard?.instantiateViewController(withIdentifier: StoryboardIDKeys.CHALLENGE_TABLE_VIEW_ID) else {
            fatalError()
        }
        clearTextFields()
        present(challengeEntryController, animated: true, completion: nil) // use completion block to load?
    }
    
    @IBAction func remembeMeSwitchChanged(_ sender: Any) {
        UserSettings.current.rememberMe = rememberMeSwitch.isOn
    }
    
    @IBAction func newUserButtonTapped(_ sender: Any) {
        AccountInfoController.shared.makeNewUserAlert(forViewController: self)
    }
}













