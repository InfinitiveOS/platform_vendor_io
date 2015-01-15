#
# This policy configuration will be used by all products that
# Inherit from InfinitiveOS
#

BOARD_SEPOLICY_DIRS += \
    vendor/io/sepolicy

BOARD_SEPOLICY_UNION += \
    file.te \
    file_contexts \
    genfs_contexts \
    property_contexts \
    seapp_contexts \
    service_contexts \
    auditd.te \
    healthd.te \
    hostapd.te \
    installd.te \
    netd.te \
    property.te \
    shell.te \
    sysinit.te \
    system.te \
    ueventd.te \
    vold.te \
    mac_permissions.xml
