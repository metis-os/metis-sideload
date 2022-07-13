# Maintainer: iyamnabeen <iym.nabeen@gmail.com>
pkgname=metis-sideload
pkgver=r2.11c0cab
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
	install -Dm754 "${srcdir}/files/metis-sideload" "${pkgdir}/usr/local/bin/metis-sideload"
	install -Dm754 "${srcdir}/files/final.sh" "${pkgdir}/usr/local/bin/final.sh"
	install -Dm754 "${srcdir}/files/post-install.sh" "${pkgdir}/usr/local/config/post-install.sh"
}

pkgver() {
  cd "$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
