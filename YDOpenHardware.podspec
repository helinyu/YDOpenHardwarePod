
Pod::Spec.new do |s|
	s.name         = 'YDOpenHardware'
	s.version      = '0.2.6'
	s.summary      = '蓝牙硬件开发平台，数据存储'
	s.ios.deployment_target = '7.0'
	s.homepage     = 'https://github.com/helinyu/YDOpenHardwarePod'
	s.license      = 'MIT'
	s.authors      = { "felix" => "2319979647@qq.com" }
	s.platform     = :ios, '7.0'
	s.source       = {:git => 'https://github.com/helinyu/YDOpenHardwarePod.git', :tag => s.version}
	s.source_files = 'ydOpenHardware/Bluetooth/*.{h,m}','ydOpenHardware/extension/*.{h,m}'
	# ,'ydOpenHardware/WebView/*.{h,m}'
	s.requires_arc = true
	s.description  = <<-DESC
	                YDOpenHardware is for easier to use
	               DESC
   # dependency
    s.dependency 'Masonry', '~> 1.0.2'
    s.dependency 'BabyBluetooth', '~> 0.7.0'
	s.dependency 'WebViewJavascriptBridge', '~> 6.0.2'
    s.dependency 'SVProgressHUD', '~> 2.1.2'
	s.dependency 'NJKWebViewProgress', '~> 0.2.3'
    s.dependency 'YYModel', '~> 1.0.4'
	s.dependency 'MJRefresh', '~> 3.1.12'
    s.dependency 'Reachability', '~> 3.2'

    # s.vendored_frameworks = 'framework/*.framework'

end