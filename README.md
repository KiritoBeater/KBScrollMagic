# KBScrollMagic

[![CI Status](http://img.shields.io/travis/liuxingqipan/KBScrollMagic.svg?style=flat)](https://travis-ci.org/liuxingqipan/KBScrollMagic)
[![Version](https://img.shields.io/cocoapods/v/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)
[![License](https://img.shields.io/cocoapods/l/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)
[![Platform](https://img.shields.io/cocoapods/p/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)

KBScrollMagic is a solution for the gesture conflict between multiple scrollView when we have some scrollViews or tableViews that added to a superview that is also scrollView. Easy to use!

![gif picture](ScreenShots/gif0.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8 +
- Xcode 8 
- Swift 3

## Installation

KBScrollMagic is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KBScrollMagic"
```
## Usage

easy use!

call the follow code at your scrollView that it's a subview of another scrollView

```swift
tableView.kb.setinsetY(HeaderViewHeight)
tableView.kb.setSuperScrollView(UIScrollView)
```

## Author

Kirito, 1353137283@qq.com

## License

KBScrollMagic is available under the MIT license. See the LICENSE file for more info.
