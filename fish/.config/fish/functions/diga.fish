function diga -a host -d 'Fast query of DNS results from dig'
    test -z $host; and begin
        echo >&2 (status function)': expected host'
        return 1
    end

    dig +nocmd $host any +multiline +noall +answer
end
