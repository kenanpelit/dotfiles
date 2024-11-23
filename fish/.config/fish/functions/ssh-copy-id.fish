# Shell script to install your public key on a remote machine. Takes the
# remote machine name as an argument. Obviously, the remote machine must
# accept password authentication or one of the other keys in your ssh-agent
# for this to work.
function ssh-copy-id -d 'Install your public key on a remote machine.'
    argparse -N1 -xa,i h/help a-agent 'i-id=+' -- $argv
    or begin
        ssh-copy-id:usage (status function) >&2
        return 1
    end

    test -z $_flag_help
    or begin
        ssh-copy-id:usage (status function)
        return
    end

    set -l files
    set -l identities

    if test -n "$_flag_id"
        for pattern in $_flag_id
            for name in (eval echo $pattern)
                test -f {$name}.pub; and set name {$name}.pub
                set -a files
            end
        end

        for file in $files
            test -f $file; and set -a identities (string escape (cat $file))
        end
    else if test -n "$_flag_agent"
        if test -n "$SSH_AUTH_SOCK"; and ssh-add -L >/dev/null 2>&1
            ssh-add -L | while read identity
                set -a identities (string escape $identity)
            end
        end
    else if test -f $HOME/.ssh/id_rsa.pub
        set identities $identities (string escape (cat $HOME/.ssh/id_rsa.pub))
    else if test -f $HOME/.ssh/id_dsa.pub
        set identities $identities (string escape (cat $HOME/.ssh/id_dsa.pub))
    end

    if not set -q identities[1]
        echo >&2 Error: No identities found.
        ssh-copy-id:usage (status function)
        return 1
    end

    printf '%s\n' (string unescape $identities) |
        ssh $argv 'umask 077; test -d ~/.ssh || mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys'
    or return 10

    echo "Now try logging into the machine with \"ssh '$argv'\" and check in:

  ~/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.
"
end

function ssh-copy-id:usage
    set -l message \
        "Usage: {$argv[1]} [[--id IDFILE]+|[--agent]] [user@]machine [ssh-args]
       {$argv[1]} -h|--help

Copies one or more SSH identities from this computer to the remote computer.

The flag '--id IDFILE' specifies a local identity file or a pattern of
identity files to be copied to the remote computer. If \"IDFILE\" has a file
next to it called \"IDFILE.pub\", the \"IDFILE.pub\" file will be used for the
identity. '--id IDFILE' may be specified multiple times, but may not be used
with '--agent'.

The flag '--agent' specifies that 'ssh-agent -L' should be used to obtain
the identities that will be sent to the remote computer. Note that all
found identities will be sent. '-agent' cannot be used with '-id IDFILE'.

When neither '-id IDFILE' nor '-agent' have been specified, then one of
'~/.ssh/id_rsa.pub' or '~/.ssh/id_dsa.pub' will be used \(in that order\),
if they exist. If neither exists, an error will be raised."

    printf '%s\n' $message
end
