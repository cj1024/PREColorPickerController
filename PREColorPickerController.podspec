Pod::Spec.new do |s|
  s.name         = "PREColorPickerController"
  s.version      = "0.2"
  s.summary      = "Color Picker for iOS"
  s.homepage     = "https://github.com/pres/PREColorPickerController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Paul Steinhilber" => "git@paulsteinhilber.de" }
  s.source       = { :git => "https://github.com/pres/PREColorPickerController.git", :tag => s.version.to_s }
  s.source_files = 'PREColorPickerController/*.{h,m}'
  s.resources    = 'PREColorPickerController/PREColorPickerController.xib'
  s.screenshots  = ['screenshots/01.png', 'screenshots/02.png']
  s.platform     = :ios, '7.0'
  s.requires_arc = true
end
