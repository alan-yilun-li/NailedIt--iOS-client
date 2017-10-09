//
//  AccountManager.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-09-28.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate let BASE_URL = "https://3b579900.ngrok.io"
fileprivate let GET_TOKEN_ENDPOINT = "/users/tokens"

class AccountManager {

    static let shared = AccountManager()
    private init() {
    }
    
    // Perform Login
    func performLogin(username: String, password: String, callback: @escaping (Bool) -> Void) {
        let urlEncodedParameters = "?" + "username=\(username)&" + "password=\(password)"
        Alamofire.request(BASE_URL + GET_TOKEN_ENDPOINT + urlEncodedParameters, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                print(response)
                if let jsonvalue = response.result.value {
                    
                    // Parse accessToken and put it
                    let json = JSON(jsonvalue)
                    
                    if json["errors"] != JSON.null {
                        // error occured
                        print("Status code: \(json["errors"]["status"])")
                        print("Error Message: \(json["message"])")
                        callback(true)
                        return
                    }
                }
            callback(true)
        }
    }
    
    func makeAccount(username: String, password: String, callback: @escaping (Bool) -> Void) {
        let success = true // Debugging output before actual server-communicating code is made
        callback(success)
    }
    
    
    func checkPassword(username: String, passwordToCheck: String, callback: @escaping (Bool) -> Void) {
        let success = true // Debugging output before actual server-communicating code is made
        callback(success)
    }
    
    func updateAccount(username: String?, password: String?, callback: @escaping (Bool) -> Void) {
        let success = true // Debugging output before actual server-communicating code is made
        callback(success)
    }
    
}
