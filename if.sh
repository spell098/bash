#!/bin/bash

read -p "Your name? " name

if [[ $name = $USER ]]; then
	echo "Hello, me."
else
    echo "Hello, $name."
fi

if ! rm hello.txt; then echo "Couldn't delete hello.txt." >&2; exit ; fi
#delete if it exists. If not, the text is displayed
