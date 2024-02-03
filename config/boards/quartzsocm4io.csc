# Rockchip RK3566 quad core 2GB-8GB GBE PCIe USB3
declare -g BOARD_NAME="Pine SOQuartz"
declare -g BOARDFAMILY="rockchip64"
declare -g BOARD_MAINTAINER=""
declare -g BOOTCONFIG="soquartz-cm4-rk3566_defconfig"
declare -g BOOT_SOC="rk3566"
declare -g KERNEL_TARGET="current,edge"
declare -g FULL_DESKTOP="yes"
declare -g BOOT_LOGO="desktop"
declare -g BOOT_FDT_FILE="rockchip/rk3566-soquartz-cm4.dtb"
declare -g SRC_EXTLINUX="no"
declare -g IMAGE_PARTITION_TABLE="gpt"

function post_family_config__soquartz_use_mainline_uboot() {
    display_alert "$BOARD" "mainline u-boot overrides" "info"

    declare -g BOOTSOURCE="https://github.com/Kwiboo/u-boot-rockchip.git"
    declare -g BOOTBRANCH="branch:rk3568-2023.10"
    declare -g BOOTDIR="u-boot-${BOARD}"
    declare -g BOOTPATCHDIR="v2024.01"

    declare -g DDR_BLOB="rk35/rk3566_ddr_1056MHz_v1.18.bin"
    declare -g BL31_BLOB="rk35/rk3568_bl31_v1.43.elf"

    declare -g UBOOT_TARGET_MAP="BL31=${RKBIN_DIR}/${BL31_BLOB} ROCKCHIP_TPL=${RKBIN_DIR}/${DDR_BLOB};;u-boot-rockchip.bin u-boot.itb idbloader.img"
    unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd # disable stuff from rockchip64_common; we're using binman here which does all the work already

    # Just use the binman-provided u-boot-rockchip.bin, which is ready-to-go
    function write_uboot_platform() {
        dd if=${1}/u-boot-rockchip.bin of=${2} bs=32k seek=1 conv=fsync
    }
}

function add_host_dependencies__new_uboot_wants_python3_soquartz() {
    declare -g EXTRA_BUILD_DEPS="${EXTRA_BUILD_DEPS} python3-pyelftools" # @TODO: convert to array later
}
