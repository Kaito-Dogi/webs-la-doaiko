#!/bin/sh

cd public/assets/css
sass index.scss:index.css --style compressed

cd ../../../
ruby app.rb