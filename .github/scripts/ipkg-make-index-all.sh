#!/usr/bin/env bash
set -e

pkgs_dir=$1

if [ -z $pkgs_dir ] || [ ! -d $pkgs_dir ]; then
	echo "Usage: ipkg-make-index-all <package_directory>" >&2
	exit 1
fi

for pkg_dir in `find $pkgs_dir -name '*.ipk' | sed -r 's|/[^/]+$||' | sort | uniq`; do
	cat /dev/null > $pkg_dir/Packages

	for pkg in `find $pkg_dir -name '*.ipk' | sort`; do
		name="${pkg##*/}"
		name="${name%%_*}"
		[[ "$name" = "kernel" ]] && continue
		[[ "$name" = "libc" ]] && continue
		echo "Generating index for package $pkg" >&2
		file_size=$(stat -L -c%s $pkg)
		sha256sum=$(sha256sum $pkg | cut -d " " -f 1)
		# Take pains to make variable value sed-safe
		sed_safe_pkg=`echo $pkg | sed -e 's/^\.\///g' -e 's/\\//\\\\\\//g'`
		tar -xzOf $pkg ./control.tar.gz | tar xzOf - ./control | sed -e "s/^Description:/Filename: ${sed_safe_pkg##*/}\\
Size: $file_size\\
SHA256sum: $sha256sum\\
Description:/" >> $pkg_dir/Packages
		echo "" >> $pkg_dir/Packages
	done
	gzip -fk $pkg_dir/Packages
done
exit 0
