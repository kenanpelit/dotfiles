# Fish translation of https://github.com/caarlos0/dotfiles/master/bin/certp
function certp -a domain -d 'Prints cert certificate for a given domain using openssl'
    test -z $domain; and begin
        echo >&2 (status function)": domain missing"
        return 1
    end

    echo | \
        openssl s_client -showcerts -servername $domain -connect $domain:443 2>/dev/null | \
        openssl x509 -inform pem -noout -text
end
