Pod::Spec.new do |s|

  s.name             = "NestSDK"
  s.version          = "0.1.0"
  s.summary          = "Under development"

  s.description      = <<-DESC
                       The NestSDK. Under development.
                       DESC

  s.homepage         = "https://github.com/petroakzhygitov/NestSDK"
  s.license          = 'MIT'
  s.author           = { "petroakzhygitov" => "petro.akzhygitov@gmail.com" }

  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "7.0"

  s.source           = { :git => "https://github.com/petroakzhygitov/NestSDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.requires_arc = true

  s.source_files = 'NestSDK/NestSDK/**/*.{h,m}'
  s.public_header_files = 'NestSDK/NestSDK/*.{h}'

  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'Firebase', '1.2.3'
  s.dependency 'JSONModel'
  s.dependency 'SSKeychain'
  
end
