#
# Sets the following variables:
#   SimpleITK_REQUIRED_C_FLAGS
#   SimpleITK_REQUIRED_CXX_FLAGS
#   SimpleITK_REQUIRED_LINK_FLAGS
#
# In particular, this marks the "-std=", and the "-stdlib=" as
# required, if present and check if c++11 is needed.

include(CheckCXXCompilerFlag)

if( NOT DEFINED SimpleITK_REQUIRED_C_FLAGS )
  set(SimpleITK_REQUIRED_C_FLAGS "")
endif()
if( NOT DEFINED SimpleITK_REQUIRED_CXX_FLAGS )
  set(SimpleITK_REQUIRED_CXX_FLAGS "")
endif()
if( NOT DEFINED SimpleITK_REQUIRED_LINK_FLAGS )
  set(SimpleITK_REQUIRED_LINK_FLAGS "")
endif()

#
# Search CMAKE_CXX_FLAGS for flags that should be considered required,
# and propagated to other projects, via the
# SimpleITK_REQUIRED_CXX_FLAGS variable.
#

string(REPLACE " " ";" cmake_cxx_flags_list "${CMAKE_CXX_FLAGS}")

# list of regular expressions flags that are to be required flags for SimpleITK
set(required_flags_regex_to_test
  "^-std="
  "^-stdlib="
)

foreach(f ${cmake_cxx_flags_list})
  foreach( _r ${required_flags_regex_to_test} )
    string(REGEX MATCH  ${_r} _HAS_FLAG ${f} )
    if (_HAS_FLAG )
      string(FIND "${SimpleITK_REQUIRED_CXX_FLAGS}" "${f}" required)
      if(required LESS 0)
        set(SimpleITK_REQUIRED_CXX_FLAGS "${SimpleITK_REQUIRED_CXX_FLAGS} ${f}")
      endif()
    endif()
  endforeach()
endforeach()

#
# Check if we need to enable C++11 with a compiler flag
#


string(FIND "${SimpleITK_REQUIRED_CXX_FLAGS}" "-std=c++11" required)
if(required LESS 0)

  check_cxx_compiler_flag( "-std=c++11" CXX_HAS_stdcxx11)
  if (CXX_HAS_stdcxx11)

    message(STATUS "Checking if c++11 is required...")
    try_compile(SITK_CHECK_CXX11_REQUIRED
      "${PROJECT_BINARY_DIR}/CMakeTmp"
      "${CMAKE_CURRENT_LIST_DIR}/sitk_check_cxx11_required.cxx"
      OUTPUT_VARIABLE OUTPUT)
    if(${SITK_CHECK_CXX11_REQUIRED})
      message(STATUS "Checking if c++11 is required... NO" )
    else()
      message(STATUS "Checking if c++11 is required... YES" )
      file(APPEND ${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/CMakeError.log
        "Checking if C++11 required try_compile failed with the following output:\n"
        "${OUTPUT}\n")
      set(SimpleITK_REQUIRED_CXX_FLAGS "${SimpleITK_REQUIRED_CXX_FLAGS} -std=c++11")
    endif()

  endif()

endif()
