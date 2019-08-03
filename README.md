# ThemeCoordinator
A lightweight, delightfully simple way to manage app themes with Swift.

## Install

Just download `ThemeCoordinator.swift` and add it to your project. Maybe I'll add it to CocoaPods in the future.

## Changing the theme

First thing's first, you should know that the project as-is supports two `Theme`s: `light` and `dark`. With that being said, it is super easy to change the theme:

    ThemeCoordinator.shared.toggleTheme()
    
or

    ThemeCoordinator.shared.currentTheme = .light

## Applying theme changes

Implementation is wonderfully simple, concise, and readable, but it is also flexible. There are three ways to manage theme changes:

1. `UIView.coordinate`:

       let label = Label()
       label.coordinate(\.textColor, light: .black, dark: .white)
       label.coordinate(\.backgroundColor, light: .white, dark: .orange)
    
    Just for `UIButton`s:

       let button = UIButton()
       button.coordinateTitleColor(light: .orange, dark: .white)
    
2. `ThemeCoordinator.shared.coordinate(using:)`:

       ThemeCoordinator.shared.coordinate { [weak self] (theme) in
           switch theme {
           case .light: self?.setTitleColor(lightColor, for: .normal)
           case .dark: self?.setTitleColor(darkColor, for: .normal)
           }
       }
    
    This is actually the `UIButton.coordinateTitleColor` implementation.

3. With notifications:

       NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeCoordinator.themeDidChangeNotification, object: nil)
       
       @objc func themeDidChange() {
           setNeedsStatusBarUpdate()
       }

You can set `isAnimatingEnabled` to pick whether theme changes should animate. This animates theme changes added through methods 1 or 2. 
