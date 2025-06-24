project "GLFW"
    kind "StaticLib"
    language "C"
    staticruntime "off"
    warnings "off"
    cdialect "C99"
    
    targetdir ("bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}")
    objdir ("bin-int/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}/%{prj.name}")

    -- Common files
    files {
        "include/GLFW/glfw3.h",
        "include/GLFW/glfw3native.h",
        "src/context.c",
        "src/init.c",
        "src/input.c",
        "src/monitor.c",
        "src/platform.c",
        "src/vulkan.c",
        "src/window.c",
        "src/egl_context.c",
        "src/osmesa_context.c",
        "src/null_platform.h",
        "src/null_joystick.h",
        "src/null_init.c",
        "src/null_joystick.c",
        "src/null_monitor.c",
        "src/null_window.c",
    }

    -- Platform-specific configuration
    filter "system:windows"
        system "windows"
        systemversion "latest"
        
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
        
        defines {
            "_GLFW_WIN32",
            "UNICODE",
            "_UNICODE",
            "WINVER=0x0501",
            "_CRT_SECURE_NO_WARNINGS"
        }
        
        links { "gdi32" }

    filter "system:linux"
        system "linux"
        pic "On"
        
        files {
            "src/x11_platform.h",
            "src/xkb_unicode.h",
            "src/x11_init.c",
            "src/x11_monitor.c",
            "src/x11_window.c",
            "src/xkb_unicode.c",
            "src/glx_context.c",
            "src/posix_time.h",
            "src/posix_thread.h",
            "src/posix_module.c",
            "src/posix_time.c",
            "src/posix_thread.c",
            "src/posix_poll.h",
            "src/posix_poll.c",
            "src/linux_joystick.h",
            "src/linux_joystick.c"
        }
        
        defines {
            "_GLFW_X11",
            "_DEFAULT_SOURCE"
        }
        
        links {
            "X11", "Xrandr", "Xinerama", "Xcursor", "Xi", "Xext",
            "m", "pthread", "dl", "rt"
        }

    filter "system:macosx"
        system "macosx"
        pic "On"
        
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
        
        defines { "_GLFW_COCOA" }
        
        -- Corrected framework linking for all Premake versions
        buildoptions { "-fobjc-arc" }
        linkoptions { 
            "-framework Cocoa", 
            "-framework IOKit", 
            "-framework CoreFoundation",
            "-framework QuartzCore"
        }

    -- Include directories
    includedirs {
        "include",
        "src"
    }

    -- Configuration filters
    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"
        optimize "off"

    filter "configurations:Release"
        runtime "Release"
        symbols "off"
        optimize "speed"

    filter "configurations:Dist"
        runtime "Release"
        symbols "off"
        optimize "speed"
        inlining "auto"
