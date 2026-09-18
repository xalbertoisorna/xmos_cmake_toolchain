cmake_minimum_required(VERSION 3.21)
project(toolchain_test)

enable_language(CXX C ASM)

add_executable(c c.c)
add_executable(cpp cpp.cpp)
add_executable(s s.S)
add_executable(lowers lowers.S)
add_executable(ass ass.ass)

set(APPLICATIONS c cpp s lowers ass)

if(CMAKE_SYSTEM_PROCESSOR STREQUAL XCORE_XS2A OR
   CMAKE_SYSTEM_PROCESSOR STREQUAL XCORE_XS3A)
    add_executable(xc xc.xc)
    list(APPEND APPLICATIONS xc)
endif()

message(STATUS "Building for CMAKE_SYSTEM_PROCESSOR : ${CMAKE_SYSTEM_PROCESSOR}")
if(CMAKE_SYSTEM_PROCESSOR STREQUAL XCORE_XS2A)
    set(TARGET XCORE-200-EXPLORER)
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL XCORE_XS3A)    
    set(TARGET XK-EVK-XU316)
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL XCORE_VX4)
    set(TARGET XK-EVK-XU416)
else()
    message(FATAL_ERROR "Unsupported CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

include (CTest)

foreach(app IN LISTS APPLICATIONS)
    target_compile_options(${app} PRIVATE -target=${TARGET})
    target_link_options(${app} PRIVATE -target=${TARGET})
    add_test(NAME ${app} COMMAND xsim $<TARGET_FILE:${app}>)
endforeach()

target_compile_options(ass PRIVATE -x assembler-with-cpp)
