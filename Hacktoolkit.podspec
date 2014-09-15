Pod::Spec.new do |s|
  s.name         = "Hacktoolkit"
  s.version      = "0.0.1"
  s.summary      = "Hacktoolkit for iOS"

  s.description  = <<-DESC
                   This library project has many useful wrappers, data structures, and reusable components for iOS programming, Hacktoolkit-style!
                   DESC
  s.homepage     = "https://github.com/hacktoolkit/hacktoolkit-ios_lib"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Hacktoolkit" => "hello@hacktoolkit.com", "Jonathan Tsai" => "hello@jontsai.com" }
  s.social_media_url   = "http://twitter.com/hacktoolkit"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/hacktoolkit/hacktoolkit-ios_lib.git", :tag => "0.0.1" }
  s.source_files  = "Hacktoolkit/*"
  s.requires_arc = true
end
