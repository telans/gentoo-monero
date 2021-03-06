# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The secure, private, untraceable cryptocurrency"
HOMEPAGE="https://www.getmonero.org https://github.com/monero-project/monero"
SRC_URI=""
EGIT_REPO_URI="https://github.com/monero-project/monero.git"
EGIT_COMMIT="v${PV}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hw-wallet readline"

DEPEND="
	dev-libs/boost:=[nls,threads]
	dev-libs/libsodium:=
	dev-libs/openssl:=
	net-dns/unbound:=[threads]
	net-libs/czmq:=
	hw-wallet? (
		dev-libs/hidapi
		dev-libs/protobuf:=
		virtual/libusb:1
	)
	readline? ( sys-libs/readline:0= )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=("${FILESDIR}/${PN}-0.16.0.3-fix-boost-1.74.patch")

src_configure() {
	local mycmakeargs=(
		# Monero's liblmdb conflicts with the system liblmdb :(
		-DBUILD_SHARED_LIBS=OFF
		-DMANUAL_SUBMODULES=ON
	)

	cmake_src_configure
}

src_install() {
	dodoc utils/conf/monerod.conf

	find "${BUILD_DIR}/bin/" -type f -executable -print0 |
		while IFS= read -r -d '' line; do
			dobin "$line"
		done
}
