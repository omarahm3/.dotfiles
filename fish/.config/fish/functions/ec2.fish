function ec2 --description 'ec2 <key> [user@]<name> [<..rest>] | ec2 list'
    if test "$argv[1]" = list
        aws ec2 describe-instances \
            --query "Reservations[].Instances[].{Name:Tags[?Key=='Name']|[0].Value,ID:InstanceId,State:State.Name,Type:InstanceType,IP:PublicIpAddress,PrivateIP:PrivateIpAddress}" \
            --output table
        return $status
    end

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

    set -l EC2_IP (aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=*$name*" \
        "Name=instance-state-name,Values=running" \
        --query "Reservations[].Instances[].PublicIpAddress" \
        --output json | jq -r '.[]' | head -n1)

    if test -z "$EC2_IP" -o "$EC2_IP" = "null"
        echo "Error: No running EC2 instance found with name pattern '*$name*'"
        return 1
    end

    set -l ip_count (echo "$EC2_IP" | wc -l)
    if test $ip_count -gt 1
        echo "Error: Multiple running instances found with name pattern '*$name*'. Please be more specific."
        return 1
    end

    echo "Connecting to $user@$EC2_IP"
    ssh -i $key $user@$EC2_IP $rest_args
end
