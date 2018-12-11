#!/usr/bin/ruby
#
# Prints service status from `aws ecs describe-services` in a more readable
# format than huge-wall-of-JSON.
#

require 'json'

# Read env.list into a hash
env = {}
File.readlines('env.list').each do |line|
  next if line.empty? or line.start_with?('#')
  parts = line.split('=').map(&:strip)
  env[parts[0]] = parts[1] if parts.length == 2
end

cmd = "aws ecs describe-services "\
    "--cluster #{env['ECS_CLUSTER']} "\
    "--services #{env['ECS_SERVICE']} "\
    "--profile #{env['AWS_PROFILE']} "\
    "--region #{env['AWS_REGION']} "

output = `#{cmd}`
json = JSON.parse(output)
service = json['services'][0]

puts %Q{Name:            #{service['serviceName']}
Status:          #{service['status']}
Task Definition: #{service['taskDefinition'].split('/').last}
Pending Count:   #{service['pendingCount']}
Running Count:   #{service['runningCount']}
Desired Count:   #{service['desiredCount']}
}
