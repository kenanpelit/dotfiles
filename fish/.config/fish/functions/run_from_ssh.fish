function run_from_ssh -d 'Return true if this process was run from sshd'
    set -l parent (ps -o ppid= %self)
    set -l ppidsshd (ps x | grep $parent | grep sshd | grep -v grep)
    test -z $ppidsshd
end
