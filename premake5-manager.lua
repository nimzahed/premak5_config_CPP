
if  os.target() == "windows" and _ACTION:match("^vs%d%d%d%d$") ~= nil then
    StaticLibExt = ".lib"
    SharedLibExt = ".dll"
elseif os.target() == "linux" or os.target() == "android" then
    StaticLibExt = ".a"
    SharedLibExt = ".so"
elseif os.target() == "macos" then
    StaticLibExt = ".a"
    SharedLibExt = ".dylib"
elseif os.target() == "windows" then
    StaticLibExt = ".a"
    SharedLibExt = ".dll"
end

function NZA_ReplaceLibExtension(str)
    return str:gsub("%.lib$", StaticLibExt):gsub("%.a$", StaticLibExt):gsub("%.lib$", StaticLibExt)
end

function NZA_MergeTables(t1, t2)
    local result = {}

    -- Copy elements from the first table
    for _, v in ipairs(t1) do
        table.insert(result, v)
    end

    -- Copy elements from the second table
    for _, v in ipairs(t2) do
        table.insert(result, v)
    end

    return result
end

function NZA_Print(text, color )
    color = color or term.lightGray
    term.setTextColor(color)
    print(text)
    term.setTextColor(term.lightGray)
end

function NZA_newProject()
    prj_libfolder = prj_libfolder or "%{wks.location}/lib/"
    prj_configs = prj_configs or {}
    
    NZA_Print("\nMaking Project: "..prj_name, term.green)
    project(prj_name)  

        NZA_Print("Project Type : "..prj_kindof,  term.infoColor )
        kind(prj_kindof)  
        NZA_Print("Language : cpp",  term.infoColor )
        language "C++"   
        NZA_Print("Version : c++23",  term.infoColor )
        cppdialect "C++23"

        targetdir "%{wks.location}/build/bin/%{cfg.architecture}/%{cfg.buildcfg}/%{prj.name}/"
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

        removefiles { "include/**.*" }
        if prj_files ~= nil then
            files (prj_files)
        end


        

        includedirs { "%{prj.location}/include", "%{wks.location}/include" } 
        if prj_includes then 
            includedirs(prj_includes)
        end

        if prj_links then 
            NZA_Print("Linked Projects : ", term.cyan)
            for i,v in ipairs(prj_links) do 
                NZA_Print("    "..v, term.lightCyan)
            end
            links(prj_links)
        end

        --[[if prj_libs then 
            local linksTable = {}
            for i, value in ipairs(prj_libs) do 
                table.insert(linksTable, prj_libfolder..""..NZA_ReplaceLibExtension(value))
            end
            links(linksTable)
        end]]
        
        NZA_TrackLibsBasedOnProjectConfigs()

        if prj_full_libs then 
            local linksTable = {}
            NZA_Print("Static Libraries (Not Standard Location)", term.blue)
            for i, value in ipairs(prj_full_libs) do 
                NZA_Print("    "..value, term.lightBlue)
                --table.insert(linksTable, NZA_ReplaceLibExtension(value))
                linksTable[#linksTable + 1] = NZA_ReplaceLibExtension(value)
            end
            links(linksTable)
        end

        if prj_postbuild then 
            postbuildcommands(prj_postbuild)
        end
        if prj_prebuild then 
            prebuildcommands(prj_prebuild)
        end
        if prj_prelink then 
            prelinkcommands(prj_prelink)
        end
        
        if prj_defines then 
            defines(prj_defines)
        end

        if prj_kindof == "SharedLib" and os.target() == "windows" then
            defines { string.upper(prj_name).."_BUILD_DLL" }  
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
            for key, val in pairs(prj_configs) do
                filter("configurations:"..key)
                if val["defines"] then 
                    defines (val["defines"])            
                end
                filter{}
            end
        end

    
        
        if prj_pch then 
            pchheader(prj_pch)
            NZA_Print("PCH is : "..prj_pch, term.white)
        end
        if prj_pchs then 
            pchsource(prj_pchs)
            NZA_Print("PCH Source is : "..prj_pchs, term.white)
        end
end

function NZA_TrackLibsBasedOnProjectConfigs()
    
    if prj_libs then 
        NZA_Print("Static Libraries : ", term.blue)
        local said = false;
        for j,jvalue in ipairs(sln_configs) do 
            filter("configurations:"..jvalue)
            local linksTable = {}
            for i, value in ipairs(prj_libs) do 
                if not said then 
                    NZA_Print("    "..value, term.lightBlue)
                end
                table.insert(linksTable, prj_libfolder..jvalue.."/"..NZA_ReplaceLibExtension(value))
            end
            links(linksTable)
            said = true
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
    prj_postbuild = nil
    prj_prebuild = nil
    prj_prelink = nil
    prj_defines = nil
    prj_pch = nil
    prj_pchs = nil
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


function NZA_RemoveLastFolder(path)
    local parts = {}
    for part in string.gmatch(path, "([^/]+)") do
        table.insert(parts, part)
    end
    table.remove(parts, #parts)
    return table.concat(parts, "/")
end
