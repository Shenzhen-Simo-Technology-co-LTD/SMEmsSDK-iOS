Pod::Spec.new do |spec|
  spec.name         = "SMEmsSDK"
  spec.version      = "1.0.0"
  spec.summary      = "A iOS SDK and Demo to Control SIMO EMS device via BLE."
  spec.homepage     = "https://github.com/Shenzhen-Simo-Technology-co-LTD/SMEmsSDK-iOS"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = "MIT"
  spec.author       = { "GrayLand" => "441726442@qq.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/Shenzhen-Simo-Technology-co-LTD/SMEmsSDK-iOS.git", :tag => "#{spec.version}" }
  spec.source_files  = "SMEmsSDK/SMEmsSDK.framework/**/*.{h}"
  spec.vendored_frameworks = 'SMEmsSDK/SMEmsSDK.framework'
  spec.public_header_files = 'SMEmsSDK/SMEmsSDK.framework/Headers/*.h'

  spec.requires_arc = true
end
