#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroPlatform" for configuration "DEBUG"
set_property(TARGET AzeroPlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroPlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroPlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroPlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroPlatform "${_IMPORT_PREFIX}/lib/libAzeroPlatform.a" )

# Import target "AzeroEngine" for configuration "DEBUG"
set_property(TARGET AzeroEngine APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroEngine PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroEngine.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroEngine )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroEngine "${_IMPORT_PREFIX}/lib/libAzeroEngine.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
