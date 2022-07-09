# Maintainer: iyamnabeen <iym.nabeen@gmail.com>
pkgname=metis-sideload
pkgver=r2.11c0cab
pkgrel=1
pkgdesc="official installer for @metis-os"
arch=('x86_64')
url="https://github.com/metis-os/metis-sideload"
license=('MIT')
makedepends=('git')
depends=('sudo' 'grep' 'sed')
provides=("${pkgname}")
options=(!strip !emptydirs)
source=(${pkgname}::"git+${url}")
sha256sums=('SKIP')

package() {
	install -dm755 ${pkgdir}"/bin"
	install -dm755 ${pkgdir}"/bin"
	install -dm755 ${pkgdir}"/bin"
	cp ${srcdir}"/metis-sideload/files/metis-sideload" ${pkgdir}"/bin/"
	cp ${srcdir}"/metis-sideload/files/metischroot" ${pkgdir}"/bin/"
    cp ${srcdir}"/metis-sideload/files/metis-basetrap" ${pkgdir}"/bin/"
}

pkgver() {
  cd "$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
