#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint expresspay_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'expresspay_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for ExpressPaySDK.'
  s.description      = <<-DESC
ExpressPay Flutter plugin was developed and designed with one purpose: to help the iOS/Android developers easily integrate the ExpressPay API Payment Platform for a specific merchant.
                       DESC
  s.homepage         = 'https://expresspay.sa'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Express Pay' => 'itsupport@expresspay.sa' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ExpressPaySDK', '~> 1.1.5'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

end
