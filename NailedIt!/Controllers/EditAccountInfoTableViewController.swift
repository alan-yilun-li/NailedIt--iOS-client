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


class EditAccountInfoTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.tag = USERNAME_TEXT_FIELD_TAG
        passwordTextField.tag = PASSWORD_TEXT_FIELD_TAG
    
        userNameTextField.delegate = self
        passwordTextField.delegate = self
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
        // Put saving code here
    }
}

// MARK: - UITextFieldDelegate Methods
extension EditAccountInfoTableViewController: UITextFieldDelegate {

}
