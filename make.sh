#!/bin/bash

while true; do
  read -p "Chọn package (rootful [1], rootless [2], nonjb [3], roothide [4]): " scheme

  case "$scheme" in
    rootful | 1)
      export SCHEME=rootful
      break
      ;;
    rootless | 2)
      export SCHEME=rootless
      break
      ;;
    nonjb | 3)
      export SCHEME=nonjb
      break
      ;;
    roothide | 4)
      export SCHEME=roothide
      break
      ;;
    exit | e)
      exit 1
      break
      ;;
    *)
      if [ -z "$scheme" ]; then
        export SCHEME=rootful
        break
      else
        echo "Invalid scheme"
      fi
      ;;
  esac
done

if [ ! -d "packages/rootful" ]; then
  mkdir -p packages/rootful
fi

if [ ! -d "packages/rootless" ]; then
  mkdir -p packages/rootless
fi

if [ ! -d "packages/nonjb" ]; then
  mkdir -p packages/nonjb
fi

if [ ! -d "packages/roothide" ]; then
  mkdir -p packages/roothide
fi

make clean package

unset SCHEME