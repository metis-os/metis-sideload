# Maintainer: pwnwriter <iym.nabeen@gmail.com>
pkgname=metis-sideload
pkgver=r5.bb3ec59
pkgrel=1
pkgdesc="official installer for @metis-os"
arch=('x86_64')
url="https://github.com/metis-os/metis-sideload"
license=('MIT')
makedepends=('git')
depends=('bash')
provides=("${pkgname}")
options=(!strip !emptydirs)
source=(${pkgname}::"git+${url}")
sha256sums=('SKIP')

package() {
	install -Dm754 "${srcdir}/$pkgname/files/metis-sideload" "${pkgdir}/usr/local/bin/metis-sideload"
	install -Dm754 "${srcdir}/$pkgname/files/final.sh" "${pkgdir}/usr/local/bin/final.sh"
	install -Dm754 "${srcdir}/$pkgname/files/post_install.sh" "${pkgdir}/usr/local/config/post_install.sh"
}

pkgver() {
  cd "${srcdir}/$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
