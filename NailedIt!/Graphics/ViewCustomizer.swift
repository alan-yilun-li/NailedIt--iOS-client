//
//  ViewCustomizer.swift
//  NailedIt!
//
//  Created by Alan Li on 2017-09-26.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import Foundation
import UIKit

struct ViewCustomizer {
    
    static func setup(navigationBar navBar: UINavigationBar?) {
        let font = UIFont(name: "Geeza Pro", size: 24)
        UIApplication.shared.statusBarStyle = .lightContent
        navBar?.barTintColor = UIColor.nailedOrange
        navBar?.tintColor = UIColor.white
        navBar?.backgroundColor = UIColor.white
        navBar?.titleTextAttributes = [NSAttributedStringKey.font: font as Any, NSAttributedStringKey.foregroundColor: UIColor.white] 
    }
}
