//
//  SettingsViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-10-07.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

/// Controller for managing the settings page
class SettingsViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var winCountLabel: UILabel!
    @IBOutlet weak var pointsCountLabel: UILabel!
    
    
    // MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        displayNameLabel.text = UserSettings.current.displayName ?? "None"
        NotificationCenter.default.addObserver(self, selector: #selector(displayNameChanged), name: UserSettings.displayNameChangedNotif, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing account information
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                // Splitting up into multiple calls for makeCheckPasswordAlert here
                // to avoid errors with capture semantics in the callback block
                // and for scalability if extra rows are added that don't need password auth.
                
            case 0:
                AccountInfoController.shared.makeCheckPasswordAlert(forViewController: self, successAction: { [unowned self] () -> Void in
                    let chooseNameController = UIAlertController(title: "Choose a Display Name", message: "This will be what strangers and friends see you as on challenges.", preferredStyle: .alert)
                    chooseNameController.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "Display Name Here"
                    })
                    chooseNameController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    let confirmNameAction = UIAlertAction(title: "Confirm", style: .default, handler: { [unowned self] (action) in
                        
                        let displayName = chooseNameController.textFields?[0].text ?? ""
                        
                        // If the name is too short
                        if (displayName.count < 4) || (displayName.count > 8) {
                            let nameTooShortAlert = UIAlertController(title: "Uh-oh!", message: "Display names must be between 4 and 8 characters, inclusive.", preferredStyle: .alert)
                            
                            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { [unowned self] (action) in
                                self.present(nameTooShortAlert, animated: true)
                            })
                            nameTooShortAlert.addAction(tryAgainAction)
                            nameTooShortAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            
                            self.present(nameTooShortAlert, animated: true, completion: nil)
                        } else {
                            // Success case
                            UserSettings.current.displayName = displayName
                            // Do some networking here to store this info in the server.
                        }
                    })
                    chooseNameController.addAction(confirmNameAction)
                    chooseNameController.preferredAction = confirmNameAction
                    self.present(chooseNameController, animated: true)
                })
                
            case 1:
                AccountInfoController.shared.makeCheckPasswordAlert(forViewController: self, successAction: { [unowned self] () -> Void in
                    self.performSegue(withIdentifier: StoryboardIDKeys.EDIT_ACCOUNT_INFO_SEG_ID, sender: nil)
                })
                
            default: fatalError() // This should never run, switch cases should be exhaustive.
            }
        }
        
        // No other selectable rows yet.
    }

    @objc private func displayNameChanged() {
        displayNameLabel.text = UserSettings.current.displayName
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        // Presenting a warning alert
        let logoutWarning = UIAlertController(title: "Logout?", message: "You will have to re-enter your credentials to get back in.", preferredStyle: .alert)
        logoutWarning.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        logoutWarning.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [unowned self] _ in
            
            // AccountManager.shared.logout to revoke token.
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(logoutWarning, animated: true)
    }
}
