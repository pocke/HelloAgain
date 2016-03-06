# -*- encoding: utf-8 -*-
# stub: mongoid-geospatial 5.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid-geospatial"
  s.version = "5.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ryan Ong", "Marcos Piccinini"]
  s.date = "2015-07-23"
  s.description = "Mongoid Extension that simplifies MongoDB casting and operations on spatial Ruby objects."
  s.email = ["use@git.hub.com"]
  s.homepage = "https://github.com/nofxx/mongoid-geospatial"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Mongoid Extension that simplifies MongoDB Geospatial Operations."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, [">= 5.0.0.beta"])
    else
      s.add_dependency(%q<mongoid>, [">= 5.0.0.beta"])
    end
  else
    s.add_dependency(%q<mongoid>, [">= 5.0.0.beta"])
  end
end
