# smbd
# Autogenerated from man page /usr/share/man/man8/smbd.8.gz
complete -c smbd -s D -l daemon -d 'If specified, this parameter causes the server to operate as a daemon'
complete -c smbd -s i -l interactive -d 'If this parameter is specified it causes the server to run "interactively", n…'
complete -c smbd -s F -l foreground -d 'If specified, this parameter causes the main smbd process to not daemonize, i'
complete -c smbd -l no-process-group -d 'Do not create a new process group for smbd'
complete -c smbd -s b -l build-options -d 'Prints information about how Samba was built'
complete -c smbd -s p -l 'port<port' -d 'port number(s) is a space or comma-separated list of TCP ports smbd should li…'
complete -c smbd -s P -l 'profiling-level<profiling' -d 'profiling level is a number specifying the level of profiling data to be coll…'
complete -c smbd -s d -l debuglevel -l debug-stdout -d 'level is an integer from 0 to 10'
complete -c smbd -l configfile -d 'The file specified contains the configuration details required by the server'
complete -c smbd -l option -d 'Set the smb. conf(5) option "<name>" to value "<value>" from the command line'
complete -c smbd -s l -l log-basename -d 'Base directory name for log/debug files.  The extension "'
complete -c smbd -l leak-report -d 'Enable talloc leak reporting on exit'
complete -c smbd -l leak-report-full -d 'Enable full talloc leak reporting on exit'
complete -c smbd -s V -l version -d 'Prints the program version number'
complete -c smbd -s '?' -l help -d 'Print a summary of command line options'
complete -c smbd -l usage -d 'Display brief usage message'
complete -c smbd -s S -d 'parameter had been given'

