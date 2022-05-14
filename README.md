Author:
Thierry Vilmart
May 2022

# Additional functionality

A persitent storage is used, with CoreData, to save the state of the language button

# Design choices

Authentication with google SignIn
https://developers.google.com/identity/sign-in/ios/start-integrating

Combine was used for Rx reactive programming. Compared to RxSwift,
Combine is more modern and is built with performance in mind.

An Container View with an embeded Table View controller was used.
We could havve used a Table View directly in the Home View Controller.
However, our choice has better structure by splitting in several View Controllers.
Moreover, the Table View Controller simplifies the code and supervises
the table automatically.

As a consequence, it became obvious that a NotificationCenter would be suited to pass
data between the view controllers.
The recommended way to communicate between 2 view controllers repeatedly lies in
the NotificationCenter.

# Documentation

Bluetooth:
https://medium.com/macoclock/core-bluetooth-ble-swift-d2e7b84ea98e
https://developer.apple.com/documentation/corebluetooth

