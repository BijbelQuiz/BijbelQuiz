#!/bin/bash

# Minify HTML files in the redirect directory
# This script requires html-minifier-terser to be installed globally
# npm install -g html-minifier-terser

echo "Minifying HTML files..."

# Minify all HTML files in the r directory
html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --remove-redundant-attributes \
  --remove-script-type-attributes \
  --remove-tag-whitespace \
  --use-short-doctype \
  --minify-css true \
  --minify-js true \
  -o /tmp/discord.html \
  /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/discord.html

html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --remove-redundant-attributes \
  --remove-script-type-attributes \
  --remove-tag-whitespace \
  --use-short-doctype \
  --minify-css true \
  --minify-js true \
  -o /tmp/donate.html \
  /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/donate.html

html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --remove-redundant-attributes \
  --remove-script-type-attributes \
  --remove-tag-whitespace \
  --use-short-doctype \
  --minify-css true \
  --minify-js true \
  -o /tmp/index.html \
  /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/index.html

# Move minified files back
mv /tmp/discord.html /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/discord.html
mv /tmp/donate.html /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/donate.html
mv /tmp/index.html /home/thomas/Programming/BijbelQuiz/websites/bijbelquiz.app/r/index.html

echo "HTML minification complete!"