#!/usr/bin/env bash

CDIR="$(cd "$(dirname "$0")" && pwd)"

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

build_dir=$CDIR/build

rm -rf $build_dir
mkdir -p $build_dir/zsh-bin

for f in entrypoint.sh zsh.sh
do
    cp $CDIR/$f $build_dir/
done
cp $CDIR/zshrc $build_dir/.zshrc

# tag=$(curl --silent https://api.github.com/repos/romkatv/zsh-bin/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
tag=v3.0.1
distfile=zsh-5.8-darwin-x86_64
url="https://github.com/romkatv/zsh-bin/releases/download/$tag/$distfile.tar.gz"

tarname=`basename $url`

cd $build_dir/zsh-bin

[ $QUIET ] && arg_q='-q' || arg_q=''
[ $QUIET ] && arg_s='-s' || arg_s=''
[ $QUIET ] && arg_progress='' || arg_progress='--show-progress'

if [ -x "$(command -v wget)" ]; then
  wget $arg_q $arg_progress $url -O $tarname
elif [ -x "$(command -v curl)" ]; then
  curl $arg_s -L $url -o $tarname
else
  echo Install wget or curl
fi

tar -xzf $tarname
mv zsh-5.8-darwin-x86_64/* .
rm $tarname
