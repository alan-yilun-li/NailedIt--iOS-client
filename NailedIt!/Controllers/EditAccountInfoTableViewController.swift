//
//  EditAccountInfoTableViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-10-08.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

class EditAccountInfoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
