function ec2 --description 'ec2 <key> [user@]<name> [<..rest>]'
    set -l key $argv[1]
    set -l user_and_name $argv[2]
    set -l rest_args $argv[3..-1]

    if string match -q '*@*' -- $user_and_name
        set -l parts (string split '@' $user_and_name)
        set user $parts[1]
        set name $parts[2]
    else
        set user "ec2-user"
        set name $user_and_name
    end

    set -l EC2_IP (aws ec2 describe-instances --filters "Name=tag:Name,Values=*$name*" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].PublicIpAddress" --output json | jq -r '.[]')
    
    ssh -i $key $user@$EC2_IP $rest_args
end
