# author: Danny Fullerton - Mantor Organization www.mantor.org
# license: public domain
function sshfp -a fqdn -d 'A secure way to create SSHFP records'
    test -z $fqdn
    and begin
        echo >&2 Usage: (status function) FQDN
        return 1
    end

    set -l ciphers rsa dsa ecdsa ed25519
    set -l hashes sha1 sha256

    for i in (seq 1 4)
        for j in (seq 1 2)
            set -l k /etc/ssh/ssh_host_{$ciphers[$i]}_key.pub
            if test -f $k
                set -l h $hashes[$j]
                set -l sshfp=(awk '{ print $2; }' $k | openssl base64 -d -A |
                  openssl dgst -$h | sed 's/^.* /' | awk '{ print $1; }' |
                  tr a-z A-Z)
                echo $fqdn. IN SSHFP $i $j $sshfp
            end
        end
    end
end
