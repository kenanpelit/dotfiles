function sftptmp -d 'Make a temporary connection to an implicitly trusted host'
    sftp -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' $argv
end

complete -c sftptmp -w sftp
