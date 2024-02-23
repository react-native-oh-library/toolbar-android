# the minimum version of CMake
cmake_minimum_required(VERSION 3.13)
set(CMAKE_VERBOSE_MAKEFILE on)

file(GLOB rnoh_toolbar_android_SRC CONFIGURE_DEPENDS *.cpp)
add_library(rnoh_toolbar_android SHARED ${rnoh_toolbar_android_SRC})
target_include_directories(rnoh_toolbar_android PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(rnoh_toolbar_android PUBLIC rnoh)