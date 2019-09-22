source 'https://rubygems.org'


group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  # tag to 2.2.3 as starting with 2.2.5 git version currently will not run in bundle
  gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git", :tag => 'v2.2.3'
  gem 'vagrant-spec', git: "https://github.com/mitchellh/vagrant-spec.git"

  gem 'ruby-debug-ide'
  gem 'debase'
  gem 'rspec'
end

#gem 'rake'

group :plugins do
  gem 'vagrant-omnibus'
  gem 'vagrant-haipa', :path => '.'
end

#gemspec
