function man.cx -d 'Open a manpage in man.cx'
    # Copyright (c) 2010 by Ryan Tomayko <http://tomayko.com/about>
    # This is Free Software distributed under the terms of the MIT license
    argparse -N1 'h/help' -- $argv

    if not set -q $argv; or $_flag_help
        echo >&2 'Usage: man.cx [SECTION] topic...

Open manpage TOPIC on https://man.cx. When SECTION is given, it must begin
with a numeric value. Multiple TOPICs may be specified.'
        return
    end

    set -l url https://man.cx
    set -l section

    if string match -qr '^\d' $argv[1]; and test (count $argv) -gt 1
        set section '('$args[1]')'
        set -e argv[1]
    end

    for page in $argv
        open https://man.cx/$page$section
        sleep 0.5
    end
end
