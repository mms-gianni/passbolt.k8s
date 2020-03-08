@echo off

if not exist gpg-server-key.conf goto help

gpg --gen-key --batch gpg-server-key.conf

:help
echo.
echo       Please fill copy 'gpg-server-key.conf.sample' to 'gpg-server-key.conf' and fill in
echo       - Name-Email - with email
echo       - Name-Real - with full name
echo       - Passphrase - some pass phrase to protect key
echo       - (Optionally) Name-Comment
echo.
