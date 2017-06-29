


Pod::Spec.new do |s|
s.name = 'KVAlertView'
s.version = '1.1.1'
s.license = 'MIT'
s.summary = 'Custom Alert view for alert within the app.'
s.homepage = 'https://github.com/vikashideveloper/VKAlertView'
s.social_media_url = 'https://github.com/vikashideveloper/VKAlertView'
s.authors = { 'Vikash Kumar' => 'vikash.ideveloper@gmail.com' }
s.source = { :git => 'https://github.com/vikashideveloper/VKAlertView.git', :tag => s.version }

s.ios.deployment_target = '10.0'

s.source_files = 'KVAlertView/AlertView/*.*'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
#s.requires_arc = true
end









