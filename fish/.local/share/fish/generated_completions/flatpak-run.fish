# flatpak-run
# Autogenerated from man page /usr/share/man/man1/flatpak-run.1.gz
complete -c flatpak-run -s h -l help -d 'Show help options and exit'
complete -c flatpak-run -s u -l user -d 'Look for the application and runtime in per-user installations'
complete -c flatpak-run -l system -d 'Look for the application and runtime in the default system-wide installations'
complete -c flatpak-run -l installation -d 'Look for the application and runtime in the system-wide installation specifie…'
complete -c flatpak-run -s v -l verbose -d 'Print debug information during command processing'
complete -c flatpak-run -l ostree-verbose -d 'Print OSTree debug information during command processing'
complete -c flatpak-run -l arch -d 'The architecture to run'
complete -c flatpak-run -l command -d 'The command to run instead of the one listed in the application metadata'
complete -c flatpak-run -l cwd -d 'The directory to run the command in'
complete -c flatpak-run -l branch -d 'The branch to use'
complete -c flatpak-run -s d -l devel -d 'Use the devel runtime that is specified in the application metadata instead o…'
complete -c flatpak-run -l runtime -d 'Use this runtime instead of the one that is specified in the application meta…'
complete -c flatpak-run -l runtime-version -d 'Use this version of the runtime instead of the one that is specified in the a…'
complete -c flatpak-run -l share -d 'Share a subsystem with the host session'
complete -c flatpak-run -l unshare -d 'Don\\*(Aqt share a subsystem with the host session'
complete -c flatpak-run -l socket -d 'Expose a well known socket to the application'
complete -c flatpak-run -l nosocket -d 'Don\\*(Aqt expose a well known socket to the application'
complete -c flatpak-run -l device -d 'Expose a device to the application'
complete -c flatpak-run -l nodevice -d 'Don\\*(Aqt expose a device to the application'
complete -c flatpak-run -l allow -d 'Allow access to a specific feature'
complete -c flatpak-run -l disallow -d 'Disallow access to a specific feature'
complete -c flatpak-run -l filesystem -d 'Allow the application access to a subset of the filesystem'
complete -c flatpak-run -l nofilesystem -d 'Undo the effect of a previous --filesystem=FILESYSTEM in the app\\*(Aqs manife…'
complete -c flatpak-run -l add-policy -d 'Add generic policy option.  For example, "--add-policy=subsystem'
complete -c flatpak-run -l remove-policy -d 'Remove generic policy option.  This option can be used multiple times'
complete -c flatpak-run -l env -d 'Set an environment variable in the application'
complete -c flatpak-run -l unset-env -d 'Unset an environment variable in the application'
complete -c flatpak-run -l env-fd -d 'Read environment variables from the file descriptor FD, and set them as if vi…'
complete -c flatpak-run -l own-name -d 'Allow the application to own the well known name NAME on the session bus'
complete -c flatpak-run -l talk-name -d 'Allow the application to talk to the well known name NAME on the session bus'
complete -c flatpak-run -l no-talk-name -d 'Don\\*(Aqt allow the application to talk to the well known name NAME on the se…'
complete -c flatpak-run -l system-own-name -d 'Allow the application to own the well known name NAME on the system bus'
complete -c flatpak-run -l system-talk-name -d 'Allow the application to talk to the well known name NAME on the system bus'
complete -c flatpak-run -l system-no-talk-name -d 'Don\\*(Aqt allow the application to talk to the well known name NAME on the sy…'
complete -c flatpak-run -l persist -d 'If the application doesn\\*(Aqt have access to the real homedir, make the (hom…'
complete -c flatpak-run -l no-session-bus -d 'Run this instance without the filtered access to the session dbus connection'
complete -c flatpak-run -l session-bus -d 'Allow filtered access to the session dbus connection'
complete -c flatpak-run -l no-a11y-bus -d 'Run this instance without the access to the accessibility bus'
complete -c flatpak-run -l a11y-bus -d 'Allow access to the accessibility bus'
complete -c flatpak-run -l sandbox -d 'Run the application in sandboxed mode, which means dropping all the extra per…'
complete -c flatpak-run -l log-session-bus -d 'Log session bus traffic'
complete -c flatpak-run -l log-system-bus -d 'Log system bus traffic'
complete -c flatpak-run -s p -l die-with-parent -d 'Kill the entire sandbox when the launching process dies'
complete -c flatpak-run -l parent-pid -d 'Specifies the pid of the "parent" flatpak, used by --parent-expose-pids and -…'
complete -c flatpak-run -l parent-expose-pids -d 'Make the processes of the new sandbox visible in the sandbox of the parent fl…'
complete -c flatpak-run -l parent-share-pids -d 'Use the same process ID namespace for the processes of the new sandbox and th…'
complete -c flatpak-run -l instance-id-fd -d 'Write the instance ID string to the given file descriptor'
complete -c flatpak-run -l file-forwarding -d 'If this option is specified, the remaining arguments are scanned, and all arg…'
complete -c flatpak-run -l app-path -d 'Instead of mounting the app\\*(Aqs content on /app in the sandbox, mount PATH …'
complete -c flatpak-run -l usr-path -d 'Instead of mounting the runtime\\*(Aqs files on /usr in the sandbox, mount PAT…'

