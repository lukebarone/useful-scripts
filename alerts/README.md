# Useful Scripts - Alerts

## Summary

This script will alert "responsible people" when a server or node is going offline. By default, it allows you to shut down or reboot a Linux server (Debian- or Ubuntu-based).

## Requirements

- Debian or Ubuntu with bash
- A mail sending program that accepts `--return-address` and `--subject` for parameters. Tested with postfix and exim4. You will need to ensure it is configured and sending messages before using this script.

## Installation

- Save `alert.sh` to a folder that only root (or `sudo` users) can access. A great example is `/usr/local/sbin/`.
- Edit the parameters at the top of the file. Specifically:
  - `DEFAULT_ACTION` - Either `reboot` (default) or `shutdown`. This is the action that will be taken if an action is not specified on the command line.
  - `DEFAULT_DELAY` - An integer greater than 0 that says how many hours until the shutdown/reboot happens. Defaults to `8`.
  - `RESPONSIBLE_PEOPLE` - An array of email addresses to send the email to. This can include distribution lists (recommended) or individual emails.
  - `SERVER_ROLES` - An array of the services that will be affected while the server is powered down. Don't get too wordy, but specify what people may experience.
  - `FROM_EMAIL` - The email address the email will appear to be from. If you have DKIM/SPF setup on your domain, you'll need to make sure you're allowed to send emails from your server.
  - `SUBJECT` - The subject line for the email getting sent out.
  - `message` - This all happens in the `generate_message()` function, but will be the body of the message sent.

## Running it

- You can run it from a cronjob, or run it from the CLI directly.

### Parameters

```nolang
Alerter Help
Version 0.1 - Debian Edition
(C) 2022 by Luke Barone (lukebarone@gmail.com)

Arguments:
    -? -h --help                      Displays this help screen and exits
    -a --action {shutdown | reboot}   Performs the action
    -d --delay <int>                  Delay by <int> hours
    --debug                           Enables debug mode (shows variables)
```
