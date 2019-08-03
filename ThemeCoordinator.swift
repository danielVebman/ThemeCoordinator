//
//  ThemeCoordinator.swift
//  The Black Card
//
//  Created by Daniel Vebman on 7/30/19.
//  Copyright © 2019 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class ThemeCoordinator {
    static let shared = ThemeCoordinator()
    
    private let currentThemeKey = "currentTheme"
    
    static let themeDidChangeNotification = Notification.Name(rawValue: "themeDidChangeNotification")
    
    /// Closures that update the theme
    private var coordinatingClosures: [(Theme) -> ()] = []
    
    private init() { }
    
    var currentTheme: Theme {
        set(theme) {
            UserDefaults.standard.set(theme.rawValue, forKey: currentThemeKey)
            coordinatingClosures.forEach { $0(currentTheme) }
            NotificationCenter.default.post(Notification(name: ThemeCoordinator.themeDidChangeNotification))
        }
        get {
            if let themeString = UserDefaults.standard.value(forKey: currentThemeKey) as? String,
                let theme = Theme(rawValue: themeString)  {
                return theme
            } else {
                return .dark
            }
        }
    }
    
    func toggleTheme() {
        switch currentTheme {
        case .light: currentTheme = .dark
        case .dark: currentTheme = .light
        }
    }
    
    func coordinate<View: UIView, Value>(_ view: View, _ keyPath: ReferenceWritableKeyPath<View, Value>, light lightValue: Value, dark darkValue: Value) {
        coordinate { [weak view] (theme) in
            switch theme {
            case .light: view?[keyPath: keyPath] = lightValue
            case .dark: view?[keyPath: keyPath] = darkValue
            }
        }
    }
    
    func coordinate(using closure: @escaping ((Theme) -> ())) {
        coordinatingClosures.append(closure)
        closure(currentTheme) // apply current theme
    }
    
    enum Theme: String {
        case light = "light"
        case dark = "dark"
    }
}

protocol ThemeCoordinatable: UIView { }

extension ThemeCoordinatable {
    func coordinate<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, light lightValue: T, dark darkValue: T) {
        ThemeCoordinator.shared.coordinate(self, keyPath, light: lightValue, dark: darkValue)
    }
}

extension UIView: ThemeCoordinatable { }

extension UIButton {
    func coordinateTitleColor(light lightColor: UIColor, dark darkColor: UIColor) {
        ThemeCoordinator.shared.coordinate { [weak self] (theme) in
            switch theme {
            case .light: self?.setTitleColor(lightColor, for: .normal)
            case .dark: self?.setTitleColor(darkColor, for: .normal)
            }
        }
    }
}
