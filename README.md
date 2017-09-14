# luci-app-ttyd


## Building with OpenWrt/LEDE SDK

LEDE documentation: [Using the SDK][1]

Ubuntu 64bit and LEDE `ar71xx` as example:

```bash
sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev
curl -sLo- https://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-sdk-ar71xx-generic_gcc-5.4.0_musl-1.1.15.Linux-x86_64.tar.xz | tar Jx
cd lede-sdk-ar71xx-generic_gcc-5.4.0_musl-1.1.15.Linux-x86_64
./scripts/feeds update -a
./scripts/feeds install -a
git clone https://github.com/ozon/luci-app-ttyd.git package/feeds/luci-app-ttyd
make defconfig
make menuconfig
make package/feeds/luci-app-ttyd/compile
```

The compiled `.ipk` package will be in the `bin/packages` folder.


[1]: https://lede-project.org/docs/guide-developer/compile_packages_for_lede_with_the_sdk