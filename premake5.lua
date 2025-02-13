include "premake5-manager.lua"

workspace " DuskField"  
    configurations { "Debug", "Release" } 
    architecture "x86_64"
    location "./"

    -- Include build.lua files in your project
    local buildScripts = NZA_findBuildScripts(".")
    for _, script in ipairs(buildScripts) do
        --group(string.gsub(string.match(script, "/.*"), "build.lua", ""))
        group(string.gsub(script, "build.lua", ""))
        NZA_include(script)
        prj_loc = string.gsub(script, "build.lua", "")
        NZA_newProject()
        group("")
    end
