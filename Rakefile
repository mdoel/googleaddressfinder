# Copyright 2009 Mike Doel (mike@mikedoel.com)
# All rights reserved

# This file may be distributed under an MIT style license.
# See MIT-LICENSE for details.

# Code taken primarily from rubyist-aasm Rakefile

begin
  require 'rubygems'
  require 'rake/gempackagetask'
  require 'rake/testtask'
  require 'rake/rdoctask'
  require 'spec/rake/spectask'
rescue Exception
  nil
end

if `ruby -Ilib -rgoogleaddressfinder -e "print GoogleAddressFinder.Version"` =~ /([0-9.]+)$/
  CURRENT_VERSION = $1
else
  CURRENT_VERSION = '0.0.1'
end
$package_version = CURRENT_VERSION

PKG_FILES = FileList['[A-Z]*',
'lib/*.rb',
'doc/**/*',
'spec/*.rb'
]

desc 'Generate documentation for the Google address finder.'
rd = Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.template = 'doc/jamis.rb'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'GoogleAddressFinder'
  rdoc.options << '--line-numbers' << '--inline-source' <<  '--main' << 'README.rdoc' << '--title' << 'GoogleAddressFinder'
  rdoc.rdoc_files.include('README.rdoc', 'MIT-LICENSE', 'TODO', 'CHANGELOG')
  rdoc.rdoc_files.include('lib/*.rb', 'doc/**/*.rdoc')
end

if !defined?(Gem)
  puts "Package target requires RubyGEMs"
else
  spec = Gem::Specification.new do |s|
    s.name = 'googleaddressfinder'
    s.version = $package_version
    s.summary = 'Real address finder using Google Maps'
    s.description = <<-EOF
    GoogleAddressFinder is a library used to generate real addresses using Google Maps
    EOF
    s.files = PKG_FILES.to_a
    s.require_path = 'lib'
    s.has_rdoc = true
    s.extra_rdoc_files = rd.rdoc_files.reject {|fn| fn =~ /\.rb$/}.to_a
    s.rdoc_options = rd.options

    s.author = 'Mike Doel'
    s.email = 'mike@mikedoel.com'
    s.homepage = 'http://www.mikedoel.com'
  end

  package_task = Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end
end

if !defined?(Spec)
  puts "spec and cruise targets require RSpec"
else
  desc "Run all examples with RCov"
  Spec::Rake::SpecTask.new('cruise') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec', '--exclude', 'Library', '--exclude', 'rcov.rb']
  end

  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.rcov = false
    t.spec_opts = ['-cfs']
  end
end

if !defined?(Gem)
  puts "Package target requires RubyGEMs"
else
  desc "sudo gem uninstall googleaddressfinder && rake gem && sudo gem install pkg/googleaddressfinder-0.0.1.gem"
  task :reinstall do
    puts `sudo gem uninstall googleaddressfinder && rake gem && sudo gem install pkg/googleaddressfinder-0.0.1.gem`
  end
end

task :default => [:spec]
