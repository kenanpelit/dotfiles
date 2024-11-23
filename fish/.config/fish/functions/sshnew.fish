function sshnew -d 'Make an initial first connection to a host.'
    ssh -o 'StrictHostKeyChecking no' $argv
end

complete -c sshnew -w ssh
