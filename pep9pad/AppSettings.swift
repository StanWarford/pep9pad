//
//  AppSettings.swift
//  pep9pad
//
//  Created by Josh Haug on 12/31/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// Shared instance of the app's settings. 
var appSettings = AppSettings()

/// Keeps track of the user's personal preferences, including font size and dark mode.
class AppSettings {
    init() {
        
    }
    
    // MARK: - Attributes
    
    var darkModeOn: Bool = false
    // 0.0 is default size, 1.0 is biggest possible size
    var fontSize: Float = 0.0
    
    // MARK: - Methods
    
    func toggleDarkMode() {
        darkModeOn = !darkModeOn
    }
}
