## API >=23 telldir
# ../../lib/replace/tests/os2_delete.c:72:16: error: call to undeclared function 'telldir';
# ../../lib/replace/tests/os2_delete.c:89:2: error: call to undeclared function 'seekdir';

PKG_HOMEPAGE=https://talloc.samba.org/talloc/doc/html/index.html
PKG_DESCRIPTION="Hierarchical, reference counted memory pool system with destructors"
PKG_LICENSE="GPL-3.0"

PKG_VERSION=2.4.2
PKG_BASENAME=talloc-${PKG_VERSION}
PKG_EXTNAME=.tar.gz
PKG_SRCURL=https://www.samba.org/ftp/talloc/${PKG_BASENAME}${PKG_EXTNAME}

configure() {
	cat <<EOF >cross-answers.txt
Checking uname sysname type: "Linux"
Checking uname machine type: "dontcare"
Checking uname release type: "dontcare"
Checking uname version type: "dontcare"
Checking simple C program: OK
rpath library support: OK
-Wl,--version-script support: FAIL
Checking getconf LFS_CFLAGS: OK
Checking for large file support without additional flags: OK
Checking for -D_FILE_OFFSET_BITS=64: OK
Checking for -D_LARGE_FILES: OK
Checking correct behavior of strtoll: OK
Checking for working strptime: OK
Checking for C99 vsnprintf: OK
Checking for HAVE_SHARED_MMAP: OK
Checking for HAVE_MREMAP: OK
Checking for HAVE_INCOHERENT_MMAP: OK
Checking for HAVE_SECURE_MKSTEMP: OK
Checking getconf large file support flags work: OK
Checking for HAVE_IFACE_IFCONF: FAIL
EOF

	./configure \
		--host="${TARGET}" \
		--prefix="${OUTPUT_DIR}" \
		--disable-rpath \
		--disable-python \
		--cross-compile \
		--cross-answers=cross-answers.txt
}

build() {
	make -j"${JOBS}"

	mkdir -p "${OUTPUT_DIR}/lib" "${OUTPUT_DIR}/include"
	${AR-ar} rcs "${OUTPUT_DIR}/lib/libtalloc.a" bin/default/talloc*.o
	cp -f talloc.h "${OUTPUT_DIR}/include"
}

check() {
	test -f "${OUTPUT_DIR}/lib/libtalloc.a"
}
