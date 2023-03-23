Pod::Spec.new do |s|
  s.name        = "XCTestDynamicOverlay"
  s.version     = "0.1.5"
  s.summary     = "Define XCTest assertion helpers directly in your application and library code."
  s.homepage    = "https://github.com/tutu-ru-mobile/xctest-dynamic-overlay"
  s.license     = { :type => "MIT" }
  s.authors     = { "Brandon Williams" => "brandon@pointfree.co", "Stephen Celis" => "stephen@pointfree.co" }

  s.requires_arc = true
  s.swift_version = "5.1.2"
  s.osx.deployment_target = "10.15"
  s.ios.deployment_target = "13.0"
  s.watchos.deployment_target = "6.0"
  s.tvos.deployment_target = "13.0"
  s.source   = { :git => "https://github.com/tutu-ru-mobile/xctest-dynamic-overlay.git", :tag => s.version }
  s.source_files = 'Sources/**/*.swift'
  s.module_name = "XCTestDynamicOverlay"
end
