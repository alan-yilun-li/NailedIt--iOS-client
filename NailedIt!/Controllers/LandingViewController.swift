//
//  LandingViewController.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-09-26.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit

// Segue keys
private let LOGIN_SEGUE_ID = "SHOW_LOGIN"

class LandingViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // This is just to help dev. Change this when we're actually adding skipping the login page functionality.
        UserSettings.current.rememberMe = false
        
        if UserSettings.current.rememberMe ?? false {
            // Skip log-in page
        } else {
            
            guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
                fatalError()
            }
            present(loginViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}