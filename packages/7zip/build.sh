PKG_HOMEPAGE=https://www.7-zip.org
PKG_DESCRIPTION="7-Zip file archiver with a high compression ratio"
PKG_LICENSE="LGPL-2.1, BSD 3-Clause"

PKG_VERSION=23.01
PKG_BASENAME="7z2301-src"
PKG_EXTNAME=.tar.xz
PKG_SRCURL=https://www.7-zip.org/a/7z2301-src.tar.xz
SRC_DIR="${WORK_DIR}/build/${PKG_BASENAME}"

configure() {
	## Do not link to libpthread for android
	sed -i "s/LIB2 = -lpthread -ldl//" CPP/7zip/7zip_gcc.mak

	# from https://build.opensuse.org/package/view_file/openSUSE:Factory/7zip/7zip.spec?rev=5
	# Remove carriage returns from docs
	sed -i -e 's/\r$//g' DOC/*.txt
	# Remove executable perms from docs
	chmod -x DOC/*.txt
	# Remove -Werror to make build succeed
	sed -i -e 's/-Werror//' CPP/7zip/7zip_gcc.mak
}

build() {
	# from https://git.alpinelinux.org/aports/tree/community/7zip/APKBUILD?id=b4601c88f608662c75422311b7ca3c26fab4b1f4
	# cd CPP/7zip/Bundles/Alone2
	# mkdir -p b/c
	mkdir -p CPP/7zip/Bundles/Alone2/b/c

	case "${TARGET}" in
	aarch64-linux-android*)
		CFLAGS=' -march=armv8.1-a+crypto'
		CXXFLAGS=' -march=armv8.1-a+crypto'
		LDFLAGS=''
		;;
	*) ;;
	esac

	# TODO: enable asm
	# DISABLE_RAR: RAR codec is non-free
	# -D_GNU_SOURCE: broken sched.h defines
	make \
		-C CPP/7zip/Bundles/Alone2 \
		CC="$CC $CFLAGS $LDFLAGS -D_GNU_SOURCE" \
		CXX="$CXX $CXXFLAGS $LDFLAGS -D_GNU_SOURCE" \
		DISABLE_RAR=1 \
		--file ../../cmpl_clang.mak \
		--jobs "${JOBS}"

	install -Dm0755 \
		-t "${OUTPUT_DIR}/bin" \
		CPP/7zip/Bundles/Alone2/b/c/7zz

	# install -Dm0644 \
	# 	-t "${OUTPUT_DIR}"/share/doc/"$TERMUX_PKG_NAME" \
	# 	"$TERMUX_PKG_BUILDDIR"/DOC/{7zC,7zFormat,lzma,Methods,readme,src-history}.txt
	# install -Dm0644 \
	# 	-t "${OUTPUT_DIR}"/share/LICENSES/"$TERMUX_PKG_NAME" \
	# 	"$TERMUX_PKG_BUILDDIR"/DOC/{copying,License}.txt
	# }
}
