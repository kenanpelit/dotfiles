function ports -d 'Shows processes listening on ports; options are passed to lsof'
    argparse 'h/help' -- $argv

    if $_flag_help
        echo >&2 'Usage: '(status function)' [OPTION...]

Shows processes listening on ports. Any OPTIONs are passed to lsof.'
        return
    end

    lsof -iTCP -sTCP:LISTEN -P $argv
end
