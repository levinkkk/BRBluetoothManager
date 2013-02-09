Pod::Spec.new do |s|
  s.name         = "BRBluetoothManager"
  s.version      = "0.0.1"
  s.summary      = "Library for sending and receiving large data via GameKit bluetooth"
  s.homepage     = "http://github.com/darkbreed/BRBluetoothManager"
  s.license      = 'MIT'
  s.author       = { "Ben Reed" => "ben@benreed.me" }
  s.source       = { :git => "http://github.com/darkbreed/BRBluetoothManager.git", :branch => "master" }
  s.platform     = :ios, '5.1'
  s.source_files = 'BRBluetoothManager', '*.{h,m}'
  s.requires_arc = true
end
