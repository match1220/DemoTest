# SpinningIndicator

[![CI Status](https://img.shields.io/travis/toshihiro-yamazaki/SpinningIndicator.svg?style=flat)](https://travis-ci.org/toshihiro-yamazaki/SpinningIndicator)
[![Version](https://img.shields.io/cocoapods/v/SpinningIndicator.svg?style=flat)](https://cocoapods.org/pods/SpinningIndicator)
[![License](https://img.shields.io/cocoapods/l/SpinningIndicator.svg?style=flat)](https://cocoapods.org/pods/SpinningIndicator)
[![Platform](https://img.shields.io/cocoapods/p/SpinningIndicator.svg?style=flat)](https://cocoapods.org/pods/SpinningIndicator)

![Demo](https://github.com/toshihiro-yamazaki/SpinningIndicator/blob/demo/demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SpinningIndicator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SpinningIndicator'
```

## Sample Code

```swift
let indicator = SpinningIndicator(frame: UIScreen.main.bounds)
view.addSubview(indicator)
indicator.addCircle(lineColor: UIColor(red: 255/255, green: 91/255, blue: 25/255, alpha: 1), lineWidth: 2, radius: 16, angle: 0)
indicator.addCircle(lineColor: UIColor.orange, lineWidth: 2, radius: 19, angle: CGFloat.pi)
indicator.beginAnimating()
```

## Author

Toshihiro Yamazaki, yamazaki.toshihiro@icloud.com

## License

SpinningIndicator is available under the MIT license. See the LICENSE file for more info.
