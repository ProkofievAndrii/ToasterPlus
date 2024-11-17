Pod::Spec.new do |spec|
  spec.name         = "ToasterPlus"
  spec.version      = "1.0.0"
  spec.summary      = "A Swift library for customizable toast notifications."
  spec.description  = <<-DESC
    ToasterPlus is a lightweight library for displaying customizable toast messages 
    with various features like keyboard awareness, accessibility, and multiple positioning options.
  DESC
  spec.homepage     = "https://github.com/ProkofievAndrii/ToasterPlus"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Prokofiev Andrii" => "prokofiev.main@gmail.com" }
  spec.source       = { :git => "https://github.com/ProkofievAndrii/ToasterPlus.git", :tag => "#{spec.version}" }
  
  spec.platform     = :ios, "13.0"

  spec.swift_versions = ["5.0"]

  spec.source_files  = "Sources/**/*.{swift}"
  spec.exclude_files = "Demo/**"
end
