#----------------------------------------------------------------
# Generated CMake target import file for configuration "DEBUG".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AzeroOpenDenoisePlatform" for configuration "DEBUG"
set_property(TARGET AzeroOpenDenoisePlatform APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroOpenDenoisePlatform PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroOpenDenoisePlatform.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroOpenDenoisePlatform )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroOpenDenoisePlatform "${_IMPORT_PREFIX}/lib/libAzeroOpenDenoisePlatform.a" )

# Import target "AzeroOpenDenoise" for configuration "DEBUG"
set_property(TARGET AzeroOpenDenoise APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(AzeroOpenDenoise PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libAzeroOpenDenoise.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS AzeroOpenDenoise )
list(APPEND _IMPORT_CHECK_FILES_FOR_AzeroOpenDenoise "${_IMPORT_PREFIX}/lib/libAzeroOpenDenoise.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
