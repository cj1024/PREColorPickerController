Pod::Spec.new do |s|
  s.name         = "PREColorPickerController"
  s.version      = "0.1"
  s.summary      = "Color Picker for iOS"
  s.homepage     = "https://github.com/pres/PREColorPickerController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Paul Steinhilber" => "git@paulsteinhilber.de" }
  s.source       = { :git => "https://github.com/pres/PREColorPickerController.git", :tag => s.version.to_s }
  s.source_files = 'TODO:'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
end
