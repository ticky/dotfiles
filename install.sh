#!/usr/bin/env bash

for file in ~/dotfiles/*
do
  basename=$(basename $file)
  target=~/.$basename
  if [ "${basename}" == "install.sh" -o "${basename}" == "readme.md" ]
  then
    continue
  fi
  echo "installing $basename to $target"
  ln -sf $file $target
done
