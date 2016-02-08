require "./lib/recaptcha/version"

Gem::Specification.new do |s|
  s.name        = "recaptcha18"
  s.version     = Recaptcha::VERSION
  s.authors     = ["Jair Garcia"]
  s.email       = ["jairud@gmail.com"]
  s.homepage    = "https://github.com/jairud-garcia/recaptcha"
  s.summary     = s.description = "Helpers for the reCAPTCHA API for ruby 1.8.7"
  s.license     = "MIT"
  s.required_ruby_version = '>= 1.8.7'

  s.files       = `git ls-files lib README.md CHANGELOG.md LICENSE`.split("\n")

  s.add_runtime_dependency "json"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "ruby-debug", "0.10.4"
  s.add_development_dependency "activesupport", '~>2.3.11'
  s.add_development_dependency "i18n",'~> 0.5.0'
  s.add_development_dependency "maxitest"
  s.add_development_dependency "bump",'0.5.2'
  s.add_development_dependency "webmock"
  s.add_development_dependency "addressable",'2.3.6'
end
