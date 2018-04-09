Pod::Spec.new do |s|
  s.name = 'SlimTimerAPI'
  s.version = '0.1.0'
  s.license = 'Apache 2'
  s.summary = 'SlimTimer API in Swift'
  s.homepage = 'https://github.com/coodly/SlimTimerAPI'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/SlimTimerAPI.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/*.swift'

  s.requires_arc = true

  s.dependency 'SWXMLHash', '4.6.0'
end
