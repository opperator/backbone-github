guard 'coffeescript', 
  input: 'src',
  output: 'public/js'

guard 'uglify', input: 'public/js/backbone-github.js', output: "public/js/backbone-github.min.js" do
  watch (%r{public/js/backbone-github.js})
end

guard 'process', 
  name: 'rocco', 
  command: 'bundle exec rocco src/backbone-github.coffee -o docs', 
  stop_signal: "KILL" do
  watch('src/backbone-github.coffee')
end

guard 'process', 
  name: 'docs-cleanup', 
  command: 'mv docs/src/backbone-github.html docs/backbone-github.html', 
  stop_signal: "KILL" do
  watch('docs/src/backbone-github.html')
end