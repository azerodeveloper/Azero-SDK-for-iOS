#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroNVGPlatform" for configuration "DEBUG"
set_property(TARGET AzeroNVGPlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroNVGPlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroNVGPlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroNVGPlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroNVGPlatform "${_IMPORT_PREFIX}/lib/libAzeroNVGPlatform.a" )

# Import target "AzeroNVG" for configuration "DEBUG"
set_property(TARGET AzeroNVG APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroNVG PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroNVG.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroNVG )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroNVG "${_IMPORT_PREFIX}/lib/libAzeroNVG.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
