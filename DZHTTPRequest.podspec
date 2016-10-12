Pod::Spec.new do |s|  
  s.name             = "DZHTTPRequest"  
  s.version          = "1.0.1"  
  s.summary          = "网络请求私有库"   
  s.homepage         = "https://github.com/hatjs880328/DZHTTPRequest"   
  s.license          = 'MIT'  
  s.author           = { "mrshan" => "451145552@qq.com" }  
  s.source           = { :git => "https://github.com/hatjs880328/DZHTTPRequest.git", :tag => s.version.to_s }   

  s.requires_arc = true  
  s.ios.deployment_target = '8.0'
  s.source_files = 'HTTPRequest/*'  
  s.frameworks = 'Foundation','UIKit'
  s.dependencies = {
  'Alamofire' => ['3.1.5'],
  'SnapKit' => ['0.19.1']
  }

  #pod 'SnapKit', '~> 0.19.1'
end 