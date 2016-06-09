##################################################
# The MIT License (MIT)
# 
# Copyright (c) 2016 Matthias Möller
# https://github.com/TinyTinni/CMakeSourceGrouper
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
####################################################


#This cmake script should help those people, who search for a nice
#way to group up source files according to their paths in envoirments with filters e.g. Visual Studio.

#provides 2 cmake functions:
# groups_sources : takes a list of sources as an argument. The sources will be grouped together
# group_target_sources: takes a target as an argument. The sources of this target will be grouped together

#groups sources passed to the function according to the directory of the source tree
#therefore, the CMAKE_CURRENT_SOURCE_DIR will be stripped. The relative path will be the group
cmake_minimum_required(VERSION 3.0.0)
function(group_sources)
	foreach(f ${ARGN})
		get_filename_component(abs_path ${f} REALPATH )
		get_filename_component(filename ${f} NAME )
		string (REPLACE ${filename} "" abs_path ${abs_path})
		source_group("" FILES ${f})
		if(abs_path)
            #strip of the cmake source dir
			string(REPLACE ${CMAKE_CURRENT_BINARY_DIR} "Generated Files" rel_path ${abs_path}) #in case of generated files
			string(REPLACE ${CMAKE_CURRENT_SOURCE_DIR} "" rel_path ${rel_path})		
			if (rel_path)
			    string(REPLACE ${CMAKE_SOURCE_DIR} "" rel_path ${rel_path})
			endif()
			if (rel_path)
				string(REPLACE "/" "\\" group ${rel_path})
				source_group(${group} FILES ${f})
			endif(rel_path)
		endif(abs_path)
	endforeach(f)
endfunction(group_sources)


# Groups all sources of the specified target according to the dir tree
# this will affect especially the VS Filters
function(group_target_sources target)
	get_target_property(s ${target} SOURCES)
	group_sources(${s})
endfunction(group_target_sources)
