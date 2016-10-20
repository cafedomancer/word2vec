# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'word2vec/version'

Gem::Specification.new do |spec|
  spec.name          = "word2vec"
  spec.version       = Word2Vec::VERSION
  spec.authors       = ["cafedomancer"]
  spec.email         = ["cafedomancer@gmail.com"]

  spec.summary       = %q{A simple wrapper for word2vec.}
  spec.description   = %q{A simple wrapper for word2vec.}
  spec.homepage      = "https://github.com/cafedomancer/word2vec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/word2vec/extconf.rb"]

  spec.add_runtime_dependency "nmatrix", "~> 0.2.3"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
