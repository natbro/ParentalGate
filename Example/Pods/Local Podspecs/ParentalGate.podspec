#
# Be sure to run `pod lib lint ParentalGate.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ParentalGate"
  s.version          = "0.1.0"
  s.summary          = "A short description of ParentalGate."
  s.description      = <<-DESC
                       An optional longer description of ParentalGate

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/natbro/ParentalGate"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
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
