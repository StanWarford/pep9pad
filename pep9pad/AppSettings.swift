//
//  AppSettings.swift
//  pep9pad
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

/// Shared instance of the app's settings.
var appSettings = AppSettings()

/// Keeps track of the user's personal preferences, including font size and dark mode.
class AppSettings {
    init() {
        
    }
    
    // MARK: - Attributes
    
    var darkModeOn: Bool = false
    var font: UIFont = UIFont(name: "Courier", size: 12.0)!
    var fontSize: CGFloat = 12.0
    
    // MARK: - Methods
    
    func toggleDarkMode() {
        darkModeOn = !darkModeOn
    }
    
    
    /// Rather than giving `appSettings` a lot of attributes for,
    /// say, `textColor` or `backgroundColor` or whatever, I figure we
    /// should just handle this info with a method.
    func getColorFor(_ thing: ColoredObject) -> UIColor {
        switch thing {
        case .background: return darkModeOn ? UIColor(red: 0, green: 43.0/255.0, blue: 54.0/255.0, alpha: 1.0) : UIColor(red:0.99, green:0.96, blue:0.89, alpha:1.0)
        case .text: return darkModeOn ? UIColor(red:0.99, green:0.96, blue:0.89, alpha:1.0) : UIColor(red:0.35, green:0.43, blue:0.46, alpha:1.0)
        case .errorText: return .red
        }
    }
    
    
    
    enum SavedSettings: String {
        case darkModeOn = "Pep9UserDefaultsDarkModeOn"
        case fontSize = "Pep9UserDefaultsFontSize"
        //case fontName = "Pep9UserDefaultsFontName"
    }
    
    func saveSettings() {
        UserDefaults.standard.setValue(darkModeOn, forKey: SavedSettings.darkModeOn.rawValue)
        //UserDefaults.standard.setValue(font.fontName, forKey: SavedSettings.fontName.rawValue)
        UserDefaults.standard.setValue(font.pointSize, forKey: SavedSettings.fontSize.rawValue)
        // Post notification
        NotificationCenter.default.post(name: .settingsChanged, object: nil)

    }
    
    func loadSettings() {
        if let val = UserDefaults.standard.value(forKey: SavedSettings.darkModeOn.rawValue) {
            darkModeOn = val as! Bool
        }
        if let val = UserDefaults.standard.value(forKey: SavedSettings.fontSize.rawValue) {
            fontSize = val as! CGFloat
        }
    }
}
