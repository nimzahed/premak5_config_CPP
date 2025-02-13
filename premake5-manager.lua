function NZA_newProject()
    prj_libfolder = prj_libfolder or "%{wks.location}/lib/"

    project(prj_name)  
    kind(prj_kindof)  
    language "C++"   
    cppdialect "C++20"

    targetdir "%{wks.location}/build/bin/%{cfg.architecture}/%{cfg.buildcfg}"
    objdir "%{wks.location}/build/obj/%{cfg.architecture}/%{cfg.buildcfg}/%{prj.name}/" 

    --location ("%{wks.location}/"..name.."/")
    if prj_loc then 
        location (prj_loc)
    else
        location ("%{wks.location}/"..prj_name.."/")
    end
    files {
        "%{prj.location}/**.hpp", "%{prj.location}/**.h" ,
        "%{prj.location}/**.c" , "%{prj.location}/**.cpp",
        "%{prj.location}/**.lua", "%{prj.location}/**.txt", "%{prj.location}/**.ini", "%{prj.location}/**.md", 
    } 
    if prj_files ~= nil then
        files (prj_files)
    end

    includedirs { "%{prj.location}/include", "%{wks.location}/include" } 
    if prj_includes then 
        includedirs(prj_includes)
    end

    if prj_links then 
        links(prj_links)
    end
    if prj_libs then 
        local linksTable = {}
        for i, value in ipairs(prj_libs) do 
            table.insert(linksTable, prj_libfolder..""..value)
        end
        links(linksTable)
    end

    if prj_full_libs then 
        local linksTable = {}
        for i, value in ipairs(prj_full_libs) do 
            table.insert(linksTable, value)
        end
        links(linksTable)
    end

    
    filter "configurations:Debug"
        defines { "DEBUG", "_DEBUG" }  
        symbols "On" 
    filter{}
    
    filter "configurations:Release"  
        defines { "NDEBUG", "Release" }    
        optimize "On"
    filter{}

    if prj_configs then 
        for key, val in pairs(configs) do
            filter(key)
            if val["defines"] then 
                defines (val["defines"])
            end
            filter{}
        end
    end

end

function NZA_include(what)
    -- do nils then include
    prj_name = nil
    prj_loc = nil
    prj_configs = nil
    prj_files = nil
    prj_kindof = "ConsoleApp"
    prj_includes = nil
    prj_links = nil
    prj_libs = nil
    prj_full_libs = nil
    prj_libfolder = nil
    include(what)
end

-- Function to recursively search directories for build.lua files
function NZA_findBuildScripts(dir)
    local scripts = {}
    local files = os.matchfiles(path.join(dir, "**/build.lua"))
    for _, file in ipairs(files) do
        table.insert(scripts, file)
    end
    return scripts
end


