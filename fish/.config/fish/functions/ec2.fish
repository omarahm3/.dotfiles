function ec2 --description 'ec2 <key> <name> <..rest>'
  set -l EC2_IP (aws ec2 describe-instances --filters "Name=tag:Name,Values=*$argv[2]*" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].PublicIpAddress" --output json | jq -r '.[]')
  
  ssh -i $argv[1] ec2-user@$EC2_IP $argv[3..-1]
end
