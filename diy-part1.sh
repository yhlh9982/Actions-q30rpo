#!/bin/bash

#========================================================================================================================
#
# F-WRT DIY-Part1 Script
#
# Copyright (c) 2019-2024 F-WRT
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/f-wrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
#========================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# 添加自定义软件包
#
# 该脚本在 `feeds update` 之前运行。
#
# 通常，您可以在这里：
# 1. 添加第三方软件包源到 `feeds.conf.default` 文件。
# 2. 使用 `git clone` 将独立的软件包克隆到 `package/` 目录下。
#
# 请注意：
# - 克隆到 `package/` 目录下的软件包拥有最高优先级，它会“覆盖”掉来自 feeds 的同名软件包。
# - 所有的 git clone 命令都应指定目标路径为 `package/` 子目录。
#
# ----------------------------------------------------------------------------------------------------------------------


# 示例：添加一个第三方 feed 源
# sed -i '$a src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages;main' feeds.conf.default
# sed -i '$a src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2;main' feeds.conf.default


# ----------------------------------------------------------------------------------------------------------------------
# 使用 git clone 添加独立的软件包
# 格式: git clone --depth=1 [仓库地址] package/[目录名]
# ----------------------------------------------------------------------------------------------------------------------

echo " "
echo "========================================================================================================================"
echo " Cloning custom packages..."
echo "========================================================================================================================"
echo " "

# 主题
git clone --depth=1 https://github.com/sirpdboy/luci-theme-kucat.git package/luci-theme-kucat
git clone --depth=1 https://github.com/sirpdboy/luci-app-advancedplus.git package/luci-app-advancedplus

# 常用工具与应用
git clone --depth=1 https://github.com/sirpdboy/luci-app-poweroffdevice.git package/luci-app-poweroffdevice # 关机功能
git clone --depth=1 -b main https://github.com/animegasan/luci-app-wolplus.git package/luci-app-wolplus #网络唤醒
git clone --depth=1 https://github.com/asvow/luci-app-tailscale.git package/luci-app-tailscale # Tailscale
git clone --depth=1 https://github.com/lwb1978/openwrt-gecoosac.git package/luci-app-gecoosac # 集客 AC 控制器
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp  #一键自动格式化分区、扩容、自动挂载插件
git clone --depth=1 https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier # EasyTier
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/luci-app-oaf  # 应用过滤(OAF)
git clone --depth=1 https://github.com/sirpdboy/luci-app-taskplan.git package/luci-app-taskplan   #任务设置2.0版
git clone --depth=1 https://github.com/sirpdboy/luci-app-watchdog.git package/luci-app-watchdog  #看门狗
git clone --depth=1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/luci-app-mentohust  #锐捷验证 luci-app-mentohust

# 科学上网插件
# nikki
git clone --depth=1 https://github.com/nikkinikki-org/OpenWrt-nikki.git package/nikki

# openclash
rm -rf feeds/luci/applications/luci-app-openclash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash.git package/openclash

# passwall-packages
# 移除 openwrt feeds 自带的核心库
# rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
# git clone https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages

# passwall
# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall-luci

# passwall2
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2

# 更新 golang 1.25 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# smartdns
WORKINGDIR="`pwd`/feeds/packages/net/smartdns"
mkdir $WORKINGDIR -p
rm $WORKINGDIR/* -fr
wget https://github.com/pymumu/openwrt-smartdns/archive/master.zip -O $WORKINGDIR/master.zip
unzip $WORKINGDIR/master.zip -d $WORKINGDIR
mv $WORKINGDIR/openwrt-smartdns-master/* $WORKINGDIR/
rmdir $WORKINGDIR/openwrt-smartdns-master
rm $WORKINGDIR/master.zip

LUCIBRANCH="master" #更换此变量
WORKINGDIR="`pwd`/feeds/luci/applications/luci-app-smartdns"
mkdir $WORKINGDIR -p
rm $WORKINGDIR/* -fr
wget https://github.com/pymumu/luci-app-smartdns/archive/${LUCIBRANCH}.zip -O $WORKINGDIR/${LUCIBRANCH}.zip
unzip $WORKINGDIR/${LUCIBRANCH}.zip -d $WORKINGDIR
mv $WORKINGDIR/luci-app-smartdns-${LUCIBRANCH}/* $WORKINGDIR/
rmdir $WORKINGDIR/luci-app-smartdns-${LUCIBRANCH}
rm $WORKINGDIR/${LUCIBRANCH}.zip
echo " "
echo "========================================================================================================================"
echo " All custom packages have been cloned successfully."
echo "========================================================================================================================"
echo " "
