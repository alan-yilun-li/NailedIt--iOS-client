//
//  UserSettings.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-09-19.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import Foundation

// UserDefault Key Constants
private let PASSWORD_KEY = "PASSWORD"
private let USERNAME_KEY = "USERNAME"
private let TOKEN_KEY = "TOKEN"
private let REMEMBER_ME_KEY = "REMEMBE_ME"

/// Structure associated with user's default settings.
class UserSettings {
    
    // Singleton Initialization
    
    static let current = UserSettings()
    
    private init() {}
    
    var rememberMe: Bool? {
        
        didSet {
            UserDefaults.standard.setValue(username, forKey: REMEMBER_ME_KEY)
        }
    }
    
    var username: String? {
        
        didSet {
            UserDefaults.standard.setValue(username, forKey: USERNAME_KEY)
        }
    }
    
    
    var password: String? {
        
        didSet {
            UserDefaults.standard.setValue(password, forKey: PASSWORD_KEY)
        }
    }
    
    
    var token: String? {
        
        didSet {
            UserDefaults.standard.setValue(token, forKey: TOKEN_KEY)
        }
    }
    
    
    /// Retrieving settings from UserDefaults.
    /// - Note: Call this when the app starts to load settings.
    func load() {
        
        username = UserDefaults.standard.string(forKey: USERNAME_KEY)
        password = UserDefaults.standard.string(forKey: PASSWORD_KEY)
        token = UserDefaults.standard.string(forKey: TOKEN_KEY)
        rememberMe = UserDefaults.standard.bool(forKey: REMEMBER_ME_KEY)
        
    }
}
