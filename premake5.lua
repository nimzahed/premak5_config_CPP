include "premake5-manager.lua"


workspace "DuskField"  
    sln_configs = {"Debug", "Release"}
    configurations (sln_configs)
    architecture "x86_64"
    location "./"
    
    if _ACTION:match("^vs%d%d%d%d$") ~= nil   then
        buildoptions { "/utf-8" }
    elseif _ACTION == "gmake" then
        toolset "clang"
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
