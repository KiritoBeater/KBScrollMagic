# KBScrollMagic

[![CI Status](http://img.shields.io/travis/liuxingqipan/KBScrollMagic.svg?style=flat)](https://travis-ci.org/liuxingqipan/KBScrollMagic)
[![Version](https://img.shields.io/cocoapods/v/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)
[![License](https://img.shields.io/cocoapods/l/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)
[![Platform](https://img.shields.io/cocoapods/p/KBScrollMagic.svg?style=flat)](http://cocoapods.org/pods/KBScrollMagic)

KBScrollMagic is a solution for the gesture conflict between multiple scrollView when we have some scrollViews or tableViews that added to a superview that is also scrollView. Easy to use!

    ScrollView嵌套时，相同方向时的手势冲突的解决方案

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
// superScrollView: 外层的ScrollView
// insetY: 上边部分的高度
// delegate: SuperScrollView有下拉刷新时，建议实现此代理

tableView.kbs.set(superScrollView: <UIScrollView>, insetY: <CGFloat>, delegate: <KBScrollMagicDelegate>)
```

OR

```swift
tableView.kbs.setSuperScrollView(<UIScrollView>)
tableView.kbs.setinsetY(<CGFloat>)
```

if the SuperScrollView need to PullToRefresh, implement the following code
    SuperScrollView有下拉刷新时，建议实现此代理
    
```swift
tableView.kbs.setDelegate(<KBScrollMagicDelegate>)

//protocol KBScrollMagicDelegate
func scrollMagicDidEndDrag(when superScrollView: UIScrollView, offSetY: CGFloat){
    // call the RefreshCode
}

```


## Author

Kirito, 1353137283@qq.com

## License

KBScrollMagic is available under the MIT license. See the LICENSE file for more info.
