FROM --platform=linux/amd64 ubuntu:20.04 AS build
WORKDIR /sdk
RUN apt-get update -qq
RUN apt-get install -yqq wget build-essential flex bison libssl-dev bc xxd
RUN wget -q https://developer.download.nvidia.com/embedded/L4T/bootlin/aarch64--glibc--stable-final.tar.gz
RUN tar xf aarch64--glibc--stable-final.tar.gz
WORKDIR /src
RUN wget -q https://developer.download.nvidia.com/embedded/L4T/r35_Release_v3.1/sources/public_sources.tbz2
RUN tar xf public_sources.tbz2
WORKDIR /src/Linux_for_Tegra/source/public
RUN tar xf kernel_src.tbz2
ENV CROSS_COMPILE_AARCH64_PATH=/sdk/aarch64-buildroot-linux-gnu
ENV CROSS_COMPILE_AARCH64=/sdk/bin/aarch64-buildroot-linux-gnu-
COPY tegra_defconfig_extra ./
RUN cat tegra_defconfig_extra >> ./kernel/kernel-5.10/arch/arm64/configs/tegra_defconfig
RUN ./nvbuild.sh

FROM scratch AS final
COPY --from=build /src/Linux_for_Tegra/source/public/kernel/kernel-5.10/net/netfilter/ipset/*.ko /lib/modules/5.10.104-tegra/kernel/net/netfilter/ipset/
COPY --from=build /src/Linux_for_Tegra/source/public/kernel/kernel-5.10/net/netfilter/xt_nfacct.ko /lib/modules/5.10.104-tegra/kernel/net/netfilter/
COPY --from=build /src/Linux_for_Tegra/source/public/kernel/kernel-5.10/net/sched/em_ipset.ko /lib/modules/5.10.104-tegra/kernel/net/sched/
COPY --from=build /src/Linux_for_Tegra/source/public/kernel/kernel-5.10/fs/xfs/xfs.ko /lib/modules/5.10.104-tegra/kernel/fs/xfs/
