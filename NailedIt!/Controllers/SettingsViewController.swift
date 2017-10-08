//
//  SettingsViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-10-07.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing account information
        if indexPath.section == 0 {
            AccountInfoController.shared.makeCheckPasswordAlert(forViewController: self, successAction: { () -> Void in
                
                
                
                })
        }
        
        // No other selectable rows yet.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        // AccountManager.shared.logout to revoke token.
        dismiss(animated: true, completion: nil)
    }
    
}
