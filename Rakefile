
task :default do
  rake_default
end

desc "Remove Cocoapods"
task :remove_cocoapods do
  remove_cocoapods
end

private

def rake_default
  puts "Execute rake -T for rake tasks"
end

def remove_cocoapods
  sh "rm Podfile.lock"
  sh "rm -rf InstagramSimpleOAuth.xcworkspace"
  sh "rm -rf Pods"
end
