function sshtmp -d 'Make a temporary connection to an implicitly trusted host'
    ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' $argv
end

complete -c sshtmp -w ssh
