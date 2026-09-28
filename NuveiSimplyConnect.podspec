Pod::Spec.new do |s|
  s.name = "NuveiSimplyConnect"
  s.version = "1.5.1"
  s.summary = "NuveiSimplyConnect"
  s.description = <<-DESC
  NuveiSimplyConnect SDK
  DESC

  s.homepage = "https://github.com/nuvei/nuvei-mobile-simply-connect-ios"
  s.license = "Commercial"
  s.author = "Nuvei"
  s.platform = :ios, "15.0"
  s.source = { :git => "https://github.com/nuvei/nuvei-mobile-simply-connect-ios", :tag => "#{s.version}" }
  
  s.source_files  = ""

  s.vendored_frameworks = 'NuveiSimplyConnectSDK.xcframework'

  s.dependency 'Alamofire', '~> 5.7'
  s.dependency 'SwiftyJSON', '~> 5.0'
  s.dependency 'CryptoSwift', '~> 1.4'
  s.dependency 'JOSESwift', '~> 2.4'
  s.dependency 'TinyConstraints', '~> 4.0'
  s.dependency 'SDWebImage', '~> 5.15'
end
