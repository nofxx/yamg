# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec feature)

## Uncomment to clear the screen before every task
# clearing :on

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^generators/(.+)\.rb$/}) { |_m| 'spec/schemaless/worker_spec' }

  watch('spec/spec_helper.rb') { 'spec' }
end
