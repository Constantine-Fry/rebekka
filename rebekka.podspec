#
#  Be sure to run `pod spec lint rebekka.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "rebekka"
  s.version      = "1.0.3"
  s.summary      = "Rebekka - FTP/FTPS client in Swift."
  s.description  = "A simple FTP/FTPS client in Swift, written by Constantine Fry."

  s.homepage     = "https://github.com/128keaton/rebekka/"
  s.license      = "BSD 2-Clause License"
  s.author       = "Constantine Fry"

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.source        = { :git => "https://github.com/128keaton/rebekka.git", :tag => "1.0.3" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.source_files  = 'rebekka-source/**/*.swift'
  s.requires_arc  = true
end
