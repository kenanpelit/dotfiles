function dig1 -d 'Fast query domain results from dig'
    dig +noauthority +noadditional +noqr +nostats +noidentify +nocmd \
        +noquestion +nocomments $argv
end
