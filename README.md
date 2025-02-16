
# Premake Config CPP
its my premake5 configs to to make crossplatform cpp project

# Usage
its easy just put a ```build.lua``` in ur project folder and do this *configs* if you want.
> i added two **Test Directories** these are just for examples

> using ```prj_name = "ProjectName"``` is important
> 
> you are free to use any premake functions in build.lua
```lua
prj_name = nil -- "ProjectName" !important
prj_loc = nil -- "Better/Not/Change/"
prj_configs = nil -- (better use premake things by hand just implumented defines) 
--[[usage (these are implumented by default) : { 
    ["configurations:Release"] = {
        ["defines"] = {"NDEBUG", "Release"},
    }
    ["configurations:Debug"] = 
    {
        ["defines"] = {"DEBUG", "_DEBUG"},
    }
}]]
prj_files = nil 
--[[ these are implumented {
    "%{prj.location}/**.hpp", "%{prj.location}/**.h" ,
    "%{prj.location}/**.c" , "%{prj.location}/**.cpp",
    "%{prj.location}/**.lua", "%{prj.location}/**.txt", "%{prj.location}/**.ini", "%{prj.location}/**.md", 
}]]
prj_kindof = "ConsoleApp"
prj_includes = nil -- these are implumented { "%{prj.location}/include", "%{wks.location}/include" } 
prj_links = nil -- {"project1", "project2Name", "project3Chilly"}
prj_libfolder = nil -- better not cchange default is "%{wks.location}/lib/"
prj_libs = nil -- {"something.lib", "something2.lib", "something3.lib"}
prj_full_libs = nil -- same as up but with exact location for example "build/bin/x86_64/Debug/TestProject3.lib"

prj_defines = nil -- {"SOME_DEF" } 
prj_prebuild = nil - - {"commands" } 
prj_postbuild = nil - - {"commands" } 
prj_prelink = nil - - {"commands" } 

```
