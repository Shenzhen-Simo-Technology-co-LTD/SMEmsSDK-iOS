source 'https://github.com/GrayLand119/GLSpecs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'SMEmsDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SMEmsDemo
  pod "GLDemoUIKit", '~>0.0.6'

#  pod 'RxSwift', '6.1.0'
#  pod 'RxCocoa', '6.1.0'
  
  # Work fine, latest.
  pod 'SMEmsSDK', :git => "https://github.com/Shenzhen-Simo-Technology-co-LTD/SMEmsSDK-iOS.git"
  # pod 'SMEmsSDK'
#  pod 'SMEmsSDK', :path => "./"
  
  target 'SMEmsDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SMEmsDemoUITests' do
    # Pods for testing
  end

end

target 'SMEmsDemoOC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SMEmsDemo
  pod "GLDemoUIKit", '~>0.0.6'
  pod "Masonry"
#  pod 'RxSwift', '6.1.0'
#  pod 'RxCocoa', '6.1.0'
  
  # Work fine, latest.
  pod 'SMEmsSDK', :git => "https://github.com/Shenzhen-Simo-Technology-co-LTD/SMEmsSDK-iOS.git"
  # pod 'SMEmsSDK'
#  pod 'SMEmsSDK', :path => "./"
  
end
