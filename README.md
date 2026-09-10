# PickMe

PickMe is an interactive iOS app that makes group decisions quick and simple using multi-touch input.

Users place their finger on the screen and PickMe can either randomly choose 1 or more winners or divide everyone into teams.

## Features

- Multi-touch finger detection
- Random winner selection
- Multiple winner support
- Random balanced team generation
- Configurable number of winners and/or teams
- Animated countdown and selection effects
- Haptic feedback

## Built With
- Swift
- SwiftUI
- UIKit
- Xcode

## How it works

PickMe uses a custom UIKit multi-touch view to detect and tracka number of 'UITouch' objects at the same time.

The UIKit touch handling is integrated with SwiftUI using 'UIViewRepresentable', allowing the app to combine UIKit's mulit-touch with SwiftUI's state management and interface.

For winner selection, the active fingers are randomly shuffled and the requested number of winners are selected.

For team selection, the active fingers are randomly shuffled and distrubuted between the requested number of teams, keeping team sizes as balanced as possible

## Screenshots
<p align="center">
  <img src="Screenshots/home.png" width="30%" />
  <img src="Screenshots/finger-picker.png" width="30%" />
  <img src="Screenshots/team-picker.png" width="30%" />
</p>

## What I Learned

Building PickMe gave me practical experience with:

- Developing an iOS app with Swift and SwiftUI
- Integrating UIkit components into SwiftUI
- Handling simultaneous multi-touch input
- Managing application state with '@State' and '@Binding'
- Working with asynchronous and cancellable tasks
- Implementing animations and haptic feedback
- Testing and debugging on physical iOS devices
- Using Git and GitHub for version control

## Status

PickMe 1.0 is currently being prepared for release on the App Store.

