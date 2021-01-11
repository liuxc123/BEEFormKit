Pod::Spec.new do |s|
  s.name             = 'BEEFormKit'
  s.version          = '1.0.0'
  s.summary          = 'UICollectionView数据源驱动组件'
  s.homepage         = 'https://github.com/liuxc123/BEEFormKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/BEEFormKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.static_framework  =  true
  s.swift_version = '5.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'BEEFormKit/Classes/Sources/**/*.{swift}'
    ss.frameworks = 'UIKit', 'Foundation'
    ss.dependency 'BEEFormKit/Extension'
  end

  s.subspec 'Extension' do |ss|
    ss.source_files = 'BEEFormKit/Classes/Extension/**/*.{h,m}'
    ss.frameworks = 'UIKit', 'Foundation'
  end
end
