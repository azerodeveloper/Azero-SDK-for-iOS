#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroCBLPlatform" for configuration "DEBUG"
set_property(TARGET AzeroCBLPlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroCBLPlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroCBLPlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroCBLPlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroCBLPlatform "${_IMPORT_PREFIX}/lib/libAzeroCBLPlatform.a" )

# Import target "AzeroCBL" for configuration "DEBUG"
set_property(TARGET AzeroCBL APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroCBL PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroCBL.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroCBL )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroCBL "${_IMPORT_PREFIX}/lib/libAzeroCBL.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
