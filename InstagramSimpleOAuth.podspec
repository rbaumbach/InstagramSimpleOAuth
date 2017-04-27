Pod::Spec.new do |s|
  s.name                  = 'InstagramSimpleOAuth'
  s.version               = '0.4.1'
  s.summary               = 'A quick and simple way to authenticate an Instagram user in your iPhone or iPad app.'
  s.homepage              = 'https://github.com/rbaumbach/InstagramSimpleOAuth'
  s.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  s.author                = { 'Ryan Baumbach' => 'github@ryan.codes' }
  s.source                = { :git => 'https://github.com/rbaumbach/InstagramSimpleOAuth.git', :tag => s.version.to_s }
  s.requires_arc          = true
  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.public_header_files   = 'InstagramSimpleOAuth/Source/InstagramSimpleOAuth.h',   'InstagramSimpleOAuth/Source/InstagramSimpleOAuthViewController.h',
                            'InstagramSimpleOAuth/Source/InstagramLoginResponse.h', 'InstagramSimpleOAuth/Source/InstagramUser.h'
  s.source_files          = 'InstagramSimpleOAuth/Source/*.{h,m}'
  s.resources             = 'InstagramSimpleOAuth/Source/*.xib'

  s.dependency 'SimpleOAuth2', '0.1.3'
  s.dependency 'MBProgressHUD', '>= 0.9'
end
