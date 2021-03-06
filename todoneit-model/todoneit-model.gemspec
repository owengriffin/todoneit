# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{todoneit-model}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Owen Griffin"]
  s.date = %q{2010-01-31}
  s.description = %q{Models required for ToDoneIt - only really useful in conjunction with the webapp}
  s.email = %q{owen.griffin@gmail.com}
  s.files = [
    ".document",
     ".gitignore",
     "Rakefile",
     "VERSION",
     "lib/todoneit-model.rb",
     "lib/todoneit/date.rb",
     "lib/todoneit/task.rb",
     "lib/todoneit/time.rb",
     "lib/todoneit/user.rb",
     "test/helper.rb",
     "test/test_task.rb",
     "test/test_user.rb",
     "todoneit-model.gemspec"
  ]
  s.homepage = %q{http://github.com/owengriffin/todoneit-model}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{The models required for ToDoneIt}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
      s.add_runtime_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_runtime_dependency(%q<dm-validations>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 2.10.3"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_dependency(%q<dm-validations>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 2.10.3"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<dm-timestamps>, [">= 0"])
    s.add_dependency(%q<dm-validations>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 2.10.3"])
  end
end

