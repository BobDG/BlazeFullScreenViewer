Pod::Spec.new do |s|
  s.name           = 'BlazeFullScreenViewer'
  s.version        = '0.0.1'
  s.summary        = 'View photos fullscreen including using blaze media data'
  s.license 	   = 'MIT'
  s.description    = 'View photos fullscreen including paging/zooming using blaze media data'
  s.homepage       = 'https://github.com/BobDG/BlazeFullScreenViewer'
  s.authors        = {'Bob de Graaf' => 'graafict@gmail.com'}
  s.source         = { :git => 'https://github.com/BobDG/BlazeFullScreenViewer.git', :tag => s.version.to_s }
  s.source_files   = 'BlazeFullScreenViewer/*.{h,m}'
  s.resource_bundles = {
	'BlazeFullScreenViewer' => ['BlazeFullScreenViewer/**/*.{storyboard,xcassets}']
  }
  s.platform       	= :ios, '9.0'
  s.requires_arc   	= true
  s.frameworks 	    	= 'AVKit', 'AVFoundation'  
  s.dependency     'Blaze'
  s.dependency     'AFNetworking'
end
