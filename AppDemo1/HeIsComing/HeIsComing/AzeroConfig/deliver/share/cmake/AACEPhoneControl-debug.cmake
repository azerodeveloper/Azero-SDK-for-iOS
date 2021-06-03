#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroPCCPlatform" for configuration "DEBUG"
set_property(TARGET AzeroPCCPlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroPCCPlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroPCCPlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroPCCPlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroPCCPlatform "${_IMPORT_PREFIX}/lib/libAzeroPCCPlatform.a" )

# Import target "AzeroPCC" for configuration "DEBUG"
set_property(TARGET AzeroPCC APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroPCC PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroPCC.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroPCC )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroPCC "${_IMPORT_PREFIX}/lib/libAzeroPCC.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
