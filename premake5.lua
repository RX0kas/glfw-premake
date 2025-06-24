workspace "GLFW"
    configurations { "Debug", "Release" }
    platforms { "x86_64", "x86" }
    location "build"

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

    filter { "platforms:x86" }
        architecture "x86"

    filter { "platforms:x86_64" }
        architecture "x86_64"

project "glfw"
    kind "StaticLib"
    language "C"
    targetdir "lib/%{cfg.buildcfg}"

    -- GLFW version defines
    defines {
        "_GLFW_BUILD_DLL",
        "GLFW_VERSION_MAJOR=3",
        "GLFW_VERSION_MINOR=5",
        "GLFW_VERSION_MICRO=0"
    }

    -- Platform detection
    filter "system:windows"
        defines { "_GLFW_WIN32", "UNICODE", "_UNICODE", "WINVER=0x0501" }
        systemversion "latest"
        links { "gdi32" }

    filter "system:macosx"
        defines { "_GLFW_COCOA" }
        links { "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "QuartzCore.framework" }

    filter "system:linux"
        defines { "_GLFW_X11" } -- Default to X11 on Linux
        links { "X11", "Xrandr", "Xinerama", "Xcursor", "Xi", "Xext", "m", "pthread", "dl" }

    -- Common source files
    files {
        "src/internal.h",
        "src/platform.h",
        "src/mappings.h",
        "src/context.c",
        "src/init.c",
        "src/input.c",
        "src/monitor.c",
        "src/platform.c",
        "src/vulkan.c",
        "src/window.c",
        "src/egl_context.c",
        "src/osmesa_context.c"
    }

    -- Platform-specific files
    filter "system:windows"
        files {
            "src/win32_platform.h",
            "src/win32_joystick.h",
            "src/win32_init.c",
            "src/win32_joystick.c",
            "src/win32_monitor.c",
            "src/win32_window.c",
            "src/wgl_context.c",
            "src/win32_time.h",
            "src/win32_thread.h",
            "src/win32_module.c",
            "src/win32_time.c",
            "src/win32_thread.c"
        }

    filter "system:macosx"
        files {
            "src/cocoa_platform.h",
            "src/cocoa_joystick.h",
            "src/cocoa_init.m",
            "src/cocoa_joystick.m",
            "src/cocoa_monitor.m",
            "src/cocoa_window.m",
            "src/nsgl_context.m",
            "src/cocoa_time.h",
            "src/cocoa_time.c",
            "src/posix_thread.h",
            "src/posix_module.c",
            "src/posix_thread.c"
        }

    filter "system:linux"
        files {
            "src/x11_platform.h",
            "src/xkb_unicode.h",
            "src/x11_init.c",
            "src/x11_monitor.c",
            "src/x11_window.c",
            "src/xkb_unicode.c",
            "src/glx_context.c",
            "src/linux_joystick.h",
            "src/linux_joystick.c",
            "src/posix_time.h",
            "src/posix_thread.h",
            "src/posix_module.c",
            "src/posix_time.c",
            "src/posix_thread.c",
            "src/posix_poll.h",
            "src/posix_poll.c"
        }

    -- Include directories
    includedirs {
        "include",
        "src"
    }

    -- Warnings and compiler flags
    filter "action:gmake or action:clang"
        buildoptions { "-Wall" }

    filter "action:vs*"
        buildoptions { "/W3" }
        defines { "_CRT_SECURE_NO_WARNINGS" }

    -- Linux-specific settings
    filter "system:linux"
        buildoptions { "-fPIC" }
        defines { "_DEFAULT_SOURCE" }
