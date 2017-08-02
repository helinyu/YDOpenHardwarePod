
Pod::Spec.new do |s|
  s.name         = 'YDBluetooth'
  s.version      = '0.0.1'
  s.summary      = '蓝牙硬件开发平台，数据存储'
  s.ios.deployment_target = '7.0'
  s.homepage     = 'https://github.com/helinyu/YDOpenHardwarePod'
  s.license      = 'MIT'
  s.authors      = { "felix" => "2319979647@qq.com" }
  s.platform     = :ios, '7.0'
  s.source       = {:git => 'https://github.com/helinyu/YDOpenHardwarePod.git', :tag => s.version}
  s.source_files = 'ydOpenHardware/Bluetooth/*.{h,m}'
  s.requires_arc = true
  s.description  = <<-DESC
                  YDBluetooth is for easier to use to connect bluetooth and so on
                 DESC
    # s.dependency 'Masonry', '~> 1.0.2'
    # s.vendored_frameworks = 'framework/*.framework'

end