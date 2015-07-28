Pod::Spec.new do |s|
  s.name         = "LIPAImageView"
  s.version      = "0.0.2"
  s.summary      = "Rounded async imageview downloader based on SDWebImage."
  s.homepage     = "https://github.com/liyoro/LIPAImageView"
  s.license      = { :type => "MIT" }
  s.author             = { "liyoro" => "liyoro@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liyoro/LIPAImageView.git", :tag => s.version }
  s.source_files  = "*.swift"
  s.requires_arc = true
  s.dependency "SDWebImage", "~> 3.7.3"
end
