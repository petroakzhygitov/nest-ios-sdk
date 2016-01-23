Pod::Spec.new do |s|

  s.name             = "NestSDK"
  s.version          = "0.1.0"
  s.summary          = "This open-source library allows you to integrate Nest API into your iOS app."

  s.description      = <<-DESC
                       NestSDK for iOS.
                       
                       This open-source library allows you to integrate Nest API into your iOS app.

                       Learn more about Nest API at https://developer.nest.com/documentation/cloud/get-started
                       DESC

  s.homepage         = "https://github.com/petroakzhygitov/NestSDK"
  s.license          = 'MIT'
  s.author           = { "petroakzhygitov" => "petro.akzhygitov@gmail.com" }

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source           = { :git => "https://github.com/petroakzhygitov/NestSDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.requires_arc = true

  s.source_files = 'NestSDK/NestSDK/**/*.{h,m}'
  s.public_header_files = 'NestSDK/NestSDK/*.{h}'
  
  s.dependency 'Firebase', '1.2.3'
  s.dependency 'JSONModel'
  s.dependency 'SSKeychain'
  
  s.pod_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '${PODS_ROOT}/Firebase', 'MACH_O_TYPE' => 'staticlib' }
  
end
