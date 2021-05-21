#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroCorePlatform" for configuration "DEBUG"
set_property(TARGET AzeroCorePlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroCorePlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroCorePlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroCorePlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroCorePlatform "${_IMPORT_PREFIX}/lib/libAzeroCorePlatform.a" )

# Import target "AzeroCore" for configuration "DEBUG"
set_property(TARGET AzeroCore APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroCore PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroCore.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroCore )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroCore "${_IMPORT_PREFIX}/lib/libAzeroCore.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
