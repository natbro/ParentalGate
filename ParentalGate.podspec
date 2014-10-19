#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ParentalGate"
  s.version          = "0.1.1"
  s.summary          = "An iOS \"Parental Gate\" for restricting childrens' access to app features."
  s.description      = <<-DESC
iOS applications made for young children, especially those in the 'Kids Section' of the App Store, are required to have a [Parental Gate](https://developer.apple.com/app-store/parental-gates/) limiting the ability for children to inadvertently access settings, follow links to potentially unsafe web-content, or make in-app or other purchases.

The `ParentalGate` class is a simple, UI-modal `UIAlertView`-like drop-in parental gate which requires a child to read instructions about how many fingers to swipe in one of four directions in order to continue. Any incorrect taps or swipes will dismiss the gate and optionally let your code know the user failed to prove themselves an adult.

The class works on all iPhones, iPods, and iPads as far back as iOS 4.3 if you are so inclined. It handles all portrait, landscape, and upside-down orientations as well as orientation changes on the fly.
The UI presentation is a fairly universal _Do Not Enter_ symbol, and the application comes with localizations to English, Spanish, French, and Chinese.
                       DESC
  s.homepage         = "https://github.com/natbro/ParentalGate"
  s.screenshots      = ["https://raw.githubusercontent.com/natbro/images/master/ParentalGate/english.png", "https://raw.githubusercontent.com/natbro/images/master/ParentalGate/french.png", "https://raw.githubusercontent.com/natbro/images/master/ParentalGate/demo.gif"]
  s.license          = 'MIT'
  s.author           = { "Nat Brown" => "natbro@gmail.com" }
  s.source           = { :git => "https://github.com/natbro/ParentalGate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/natbro'

  s.platform     = :ios, '6.0'
  s.requires_arc = false

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'ParentalGate' => ['Pod/Assets/*.{xib,lproj}']
  }

  s.public_header_files = 'Pod/Classes/ParentalGate.h'
end
