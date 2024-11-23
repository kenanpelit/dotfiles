function addr -d 'Shows this computer\'s IP addresses'
    argparse '4/ipv4' '6/ipv6' 'l/local=?' 'r/remote' 'h/help' 'v/verbose' \
        -- $argv

    if set -q _flag_help
        echo 'Usage: '(status function)' [options]

Shows this computer\'s IP addresses. By default, shows both local and remote
addresses. If local addresses are shown, an interface name may be provided.

Options
  -lINTERFACE             Show only local addresses (for INTERFACE)
  --local INTERFACE       Show only local addresses (for INTERFACE)
  -r / --remote           Show only remote addresses
  -4 / --ipv4             Show only IPv4 addresses for local
  -6 / --ipv6             Show only IPv6 addresses for local
  -v / --verbose          Show verbose details'
        return
    end

    if set -q _flag_local; or not set -q _flag_remote
        set -q _flag_local; or set _flag_local -a

        if set -q _flag_ipv4; or not set -q _flag_ipv6
            if set -q _flag_verbose

                echo 'Local IPv4:' (ifconfig $_flag_local |
                      string replace -f -r '^\s*inet (\S+).*$' '$1')
            else
                ifconfig $_flag_local |
                string replace -f -r '^\s*inet (\S+).*$' '$1'
            end
        end

        if set -q _flag_ipv6; or not set -q _flag_ipv4
            if set -q _flag_verbose
                echo 'Local IPv6:' (ifconfig $_flag_local |
                    string replace -f -r '^\s*inet6 (\S+).*$' '$1')
            else
                ifconfig $_flag_local |
                string replace -f -r '^\s*inet6 (\S+).*$' '$1'
            end
        end
    end

    if set -q _flag_remote; or not set -q _flag_local
        if set -q _flag_verbose
            echo 'Remote:' (dig +short myip.opendns.com @resolver1.opendns.com)
        else
            dig +short myip.opendns.com @resolver1.opendns.com
        end
    end
end
