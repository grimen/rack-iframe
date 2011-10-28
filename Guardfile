guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'minitest' do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^lib/(.*)\.rb|)            { |m| "spec" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end
