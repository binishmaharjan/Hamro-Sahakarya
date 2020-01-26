# Hamro-Sahakarya
App for the Hamro Sahakarya.

## Xcode And Build Version
+ ![Xcode](https://img.shields.io/badge/Xcode-11.3-blue)
+ ![iOS](https://img.shields.io/badge/iOS-11.0%20or%20later-green)
+ ![Swift](https://img.shields.io/badge/Swift-5.0-orange)

## Libraries
|Library|Usages|
|:---:|:---:|
|RxSwift| Reactive Framework|
|Nuke| Image Download|
|PromiseKit| Asyncronous Request |
|Firebase| Backend |


## Architecture

### MVVM
[![Image from Gyazo](https://i.gyazo.com/887e0994896060ccb23a3fabefa66319.png)](https://gyazo.com/887e0994896060ccb23a3fabefa66319)

- Modal Layer: contains data access objects and validation logic. It knows how to read and write data, and it notifies the view model when data changes.

- ViewModel Layer: contains the state of the view and has methods to handle user interaction. It calls methods on the model layer to read and write data, and it notifiesthe view when the model‘s data changes. 

- View Layer: styles and displays on-screen elements. It doesn‘t contain business or validation logic. Instead, it binds its visual elements to properties on the view model. It also receives user inputs and interaction, and it calls methods on the view model in response.
