# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MockingBird"
  s.version          = "1.0.0"
  s.summary          = "A library to mock each HTTP request."
  s.description      = <<-DESC
                        MockingBird allow you to record in a JSON file each request called by the application, and then also it allows to stub the same requests with the same file saved previously.
                       DESC

  s.homepage         = "https://github.com/the-software-factory"
  s.license          = 'MIT'
  s.author           = { "centura87" => "giusbruno1987@gmail.com" }
  s.source           = { :git => "git@github.com:the-software-factory/MockingBird-iOS.git", :tag => s.version.to_s }
  s.source_files     = "*.{h,m}"
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.dependency 'OHHTTPStubs'
end
