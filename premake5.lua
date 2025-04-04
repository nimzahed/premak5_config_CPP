include "premake5-manager.lua"


workspace "DuskField"  
    configurations { "Debug", "Release" } 
    architecture "x86_64"
    location "./"
    
    if _ACTION == "vs2022" then
        buildoptions { "/utf-8" }
    elseif os.target() == "linux" then
        buildoptions { "-finput-charset=UTF-8 -fexec-charset=UTF-8" }
    end

    -- Include build.lua files in your project
    local buildScripts = NZA_findBuildScripts(".")
    for _, script in ipairs(buildScripts) do
        --group(string.gsub(string.match(script, "/.*"), "build.lua", ""))
        local projectLocation = string.gsub(script, "build.lua", "")
        group(NZA_RemoveLastFolder(projectLocation))
        NZA_include(script)
        prj_loc = projectLocation
        NZA_newProject()
        group("")
    end
