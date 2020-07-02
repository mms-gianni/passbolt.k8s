#!/bin/sh

gpg --list-secret-keys --keyid-format LONG

echo ""
echo "-------------------------------------------------"
echo ""
echo "      In above listing find your key section and line starting with [sec]"
echo "      Look for rsa4096/51B03E36ACA97B9F like string, you need value after the / char"
echo ""
