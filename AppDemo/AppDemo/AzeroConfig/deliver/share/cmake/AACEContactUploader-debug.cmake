#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroContactUplPlatform" for configuration "DEBUG"
set_property(TARGET AzeroContactUplPlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroContactUplPlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroContactUplPlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroContactUplPlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroContactUplPlatform "${_IMPORT_PREFIX}/lib/libAzeroContactUplPlatform.a" )

# Import target "AzeroContactUplEngine" for configuration "DEBUG"
set_property(TARGET AzeroContactUplEngine APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroContactUplEngine PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroContactUplEngine.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroContactUplEngine )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroContactUplEngine "${_IMPORT_PREFIX}/lib/libAzeroContactUplEngine.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
