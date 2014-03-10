AC_DEFUN([GW_INIT], [
    m4_define([_gw_dir], m4_default([$1], [libgwater]))
    m4_define([_gw_dir_canon], m4_translit(_gw_dir, [/+-], [___]))
    m4_define([_GW_USE_LIBTOOL], [])
    m4_ifblank([LT_INIT], [m4_define([_GW_USE_LIBTOOL], [yes])]) dnl Libtool redefine LT_INIT to blank when used
    m4_define([GW_INIT])
])

AC_DEFUN([_GW_CHECK], [
    AC_REQUIRE([GW_INIT])
    m4_define([_GW_PREFIX], m4_default([$4], [GW_][$1]))

    PKG_CHECK_MODULES(_GW_PREFIX, [$3])

    m4_ifblank([_GW_USE_LIBTOOL],[
        m4_define([_gw_library_suffix], [])
        m4_define([_GW_LIBRARY_VARIABLE], [])
    ],[
        m4_define([_gw_library_suffix], [l])
        m4_define([_GW_LIBRARY_VARIABLE], [LT])
    ])

    m4_syscmd([sed ]_gw_dir[/template.mk -e 's:@gw_dir@:]_gw_dir[:g' -e 's:@gw_dir_canon@:]_gw_dir_canon[:g' -e 's:@LIBRARY_VARIABLE@:]_GW_LIBRARY_VARIABLE[:g' -e 's:@library_suffix@:]_gw_library_suffix[:g' -e 's:@component@:][$2][:g' -e 's:@PREFIX@:]_GW_PREFIX[:g' > ]_gw_dir[/][$2][.mk])

    m4_undefine([_GW_PREFIX])
])

AC_DEFUN([GW_CHECK_WAYLAND], [
    gw_wayland_glib_min_version="2.36"
    gw_wayland_wayland_min_version="1.1.91"

    AC_CHECK_HEADERS([errno.h])
    _GW_CHECK([WAYLAND], [wayland], [glib-2.0 >= $gw_wayland_glib_min_version wayland-client >= $gw_wayland_wayland_min_version $2], [$1])
])

AC_DEFUN([GW_CHECK_XCB], [
    gw_wayland_glib_min_version="2.28"

    _GW_CHECK([XCB], [xcb], [glib-2.0 >= $gw_xcb_glib_min_version xcb $2], [$1])
])
