# Idea found on http://onethingwell.org; fixed up a little to handle another
# error case and show usage.
#
# Originally from:
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
function def -a word -d "Get a word's definition from dict.org"
    test -z $word; and begin
        echo >&2 (status function)': expected a WORD to define.'
        return 1
    end

    curl 'dict://dict.org/d:'$word
end
