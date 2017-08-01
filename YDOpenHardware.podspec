
Pod::Spec.new do |s|
s.name         = 'YDOpenHardware'
s.version      = '0.0.1'
s.summary      = '蓝牙硬件开发平台，数据存储'
s.homepage     = 'https://github.com/helinyu/YDOpenHardware'
s.license      = 'MIT'
s.authors      = { "felix" => "2319979647@qq.com" }
s.platform     = :ios, '7.0'
s.source       = {:git => 'https://github.com/helinyu/YDOpenHardware.git', :tag => s.version}
s.source_files = './*'
s.requires_arc = true
s.description  = <<-DESC
                YDOpenHardware is for easier to use
               DESC
end