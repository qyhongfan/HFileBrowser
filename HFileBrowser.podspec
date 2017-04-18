Pod::Spec.new do |s|
    s.name                      = 'HFileBrowser'
    s.module_name               = 'HFileBrowser'
    s.version                   = '0.2.0'
    s.summary                   = 'A Swift 2 file browser for iOS 8 and up'
    s.homepage                  = 'https://github.com/qyhongfan/HFileBrowser'
    s.license                   = 'MIT'
    s.author                    = { 'hurry.qin' => 'hurry.qin@dji.com' }
    s.platform                  = :ios, '8.0'
    s.ios.deployment_target     = '8.0'
    s.requires_arc              = true
    s.source                    = { :git => 'https://github.com/qyhongfan/HFileBrowser.git' , :tag => s.version.to_s}
    s.source_files              = 'HFileBrowser','HFileBrowser/**/*.{h,swift}'
    s.resources                 = 'HFileBrowser/*.xcassets'

end
