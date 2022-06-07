# Useful Scripts

## Summary

This repo contains scripts that do one thing, and one thing well. Each subfolder contains all the files required to run the script.

These scripts are without warranty! Some scripts require root access, which can be very dangerous! If you do not understand what the source code of the scripts do, **DO NOT RUN THEM**. By running these scripts, I assume you have permission to do so on the computers you are running them from.

## Table of Contents

- [Alert for service disruptions](/alerts) - Sends an email to Responsible People when servers are shutting down or rebooting. Useful when only one node runs a service and it needs a reboot.

## Contributing

- All scripts need to pass their testing. This means:
  - Bash Shell Scripts pass Shell Check
  - Python Scripts pass Pylint and Pytest (if tests are written)
- Create an issue above to see if the issue can be resolved, or if a fix is needed. If a fix is needed, and you're willing to do it:
  - Fork this repo
  - Make the changes
  - Mention your issue in the commit message (using `Fixes #x` syntax)