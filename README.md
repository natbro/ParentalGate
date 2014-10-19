# ParentalGate

[![CI Status](http://img.shields.io/travis/Nat Brown/ParentalGate.svg?style=flat)](https://travis-ci.org/natbro/ParentalGate)
[![Version](https://img.shields.io/cocoapods/v/ParentalGate.svg?style=flat)](http://cocoadocs.org/docsets/ParentalGate)
[![License](https://img.shields.io/cocoapods/l/ParentalGate.svg?style=flat)](http://cocoadocs.org/docsets/ParentalGate)
[![Platform](https://img.shields.io/cocoapods/p/ParentalGate.svg?style=flat)](http://cocoadocs.org/docsets/ParentalGate)

## Description
iOS applications made for young children, especially those in the 'Kids Section' of the App Store, are required to have a [Parental Gate](https://developer.apple.com/app-store/parental-gates/) limiting the ability for children to inadvertently access settings, follow links to potentially unsafe web-content, or make in-app or other purchases.

The `ParentalGate` class is a simple, UI-modal `UIAlertView`-like drop-in parental gate which requires a child to read instructions about how many fingers to swipe in one of four directions in order to continue. Any incorrect taps or swipes will dismiss the gate and optionally let your code know the user failed to prove themselves an adult.

The class works on all iPhones, iPods, and iPads as far back as iOS 4.3 if you are so inclined. It handles all portrait, landscape, and upside-down orientations as well as orientation changes on the fly.
****
->![Parental Gate Example](https://github.com/natbro/ParentalGate/releases/download/0.1.0/demo.gif)<-
 
-> the included demonstration/test application <-
****
The UI presentation is a fairly universal _Do Not Enter_ symbol, and the application comes with localizations to English, Spanish, French, and Chinese. Please feel free to submit pull-requests for additional localizations if you make them (be sure to test that your text fits in the _Do Not Enter_ sign properly).

## Usage

``` objc
#import "ParentalGate.h" 

ParentalGate *myParentalGate;
myParentalGate = [ParentalGate newWithCompletion:^(BOOL success){
  // this is your code which runs when the gate is dismissed
  if (success) {
    // the user has proven they are not a child
  } else {
    // the user has not proven they are a child
  }
}];
[myParentalGate show];
```
or if you’re feeling very concise and don’t have anything to do if the user fails to prove themselves an adult:

``` objc
[ParentalGate showWithSuccess:^{
  // this block will only run if the user proves they are not a child
}];
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
None. ParentalGate is a standalone `UIAlertView`-like `UIView` class and uses only `UIKit`.

## Installation

ParentalGate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ParentalGate"

## Author

Nat Brown, natbro@gmail.com

## License

ParentalGate is available under the MIT license. See the LICENSE file for more info.

