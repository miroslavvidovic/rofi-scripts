#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Miroslav Vidovic
#   file:      books-search.sh
#   created:   13.08.2017.-08:06:54
#   revision:  ---
#   version:   1.0
# -----------------------------------------------------------------------------
# Requirements:
#   rofi
# Description:
#   Use rofi to search my books.
# Usage:
#   books-search.sh
# -----------------------------------------------------------------------------
# Script:

# Books directory
BOOKS_DIR=~/Books
mkdir -p ~/Books

# Save find result to F_ARRAY
readarray -t F_ARRAY <<< "$(find "$BOOKS_DIR" -type f -name '*.pdf')"

# Associative array for storing books
# key => book name
# value => absolute path to the file
# BOOKS['filename']='path'
declare -A BOOKS

# Add elements to BOOKS array
get_books() {

  # if [ ${#F_ARRAY[@]} != 0 ]; then
  if [[ ! -z ${F_ARRAY[@]} ]]; then
    for i in "${!F_ARRAY[@]}"
    do
      path=${F_ARRAY[$i]}
      file=$(basename "${F_ARRAY[$i]}")
      BOOKS+=(["$file"]="$path")
    done
  else
      echo "$BOOKS_DIR is empty!"
      echo "Please put some books in it."
      echo "Only .pdf files are accepted."
      exit
  fi

  
}

# List for rofi
gen_list(){
  for i in "${!BOOKS[@]}"
  do
    echo "$i"
  done
}

main() {
  get_books
  book=$( (gen_list) | rofi -dmenu -i -matching fuzzy -no-custom -location 0 -p "Book > " )

  if [ -n "$book" ]; then
    xdg-open "${BOOKS[$book]}"
  fi
}

main

exit 0
