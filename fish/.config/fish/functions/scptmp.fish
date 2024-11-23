function scptmp -d 'Make a temporary connection to an implicitly trusted host'
    scp -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' $argv
end

complete -c scptmp -w scp
