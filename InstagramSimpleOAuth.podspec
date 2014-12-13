Pod::Spec.new do |s|
  s.name                  = 'InstagramSimpleOAuth'
  s.version               = '0.3.0'
  s.summary               = 'A quick and simple way to authenticate an Instagram user in your iPhone or iPad app.'
  s.homepage              = 'https://github.com/rbaumbach/InstagramSimpleOAuth'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Ryan Baumbach' => 'rbaumbach.github@gmail.com' }
  s.source                = { :git => 'https://github.com/rbaumbach/InstagramSimpleOAuth.git', :tag => s.version.to_s }
  s.requires_arc          = true
  s.platform              = :ios
  s.ios.deployment_target = '7.0'
  s.public_header_files   = 'InstagramSimpleOAuth/InstagramSimpleOAuth.h',   'InstagramSimpleOAuth/InstagramSimpleOAuthViewController.h',
                            'InstagramSimpleOAuth/InstagramLoginResponse.h', 'InstagramSimpleOAuth/InstagramUser.h'
  s.source_files          = 'InstagramSimpleOAuth/Source/*.{h,m}'
  s.resources             = 'InstagramSimpleOAuth/Source/*.xib'
  s.frameworks            = 'Foundation', 'UIKit'

  s.dependency 'SimpleOAuth2', '0.0.3'
  s.dependency 'MBProgressHUD', '~> 0.9'
end
