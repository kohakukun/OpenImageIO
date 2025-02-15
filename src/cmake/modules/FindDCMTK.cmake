# Module to find DCMTK
#
# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: Apache-2.0
# https://github.com/AcademySoftwareFoundation/OpenImageIO
#
# This module will first look into the directories defined by the variables:
#   - DCMTK_ROOT, DCMTK_INCLUDE_PATH, DCMTK_LIBRARY_PATH
#
# This module defines the following variables:
#
# DCMTK_FOUND            True if DCMTK was found.
# DCMTK_INCLUDES         Where to find DCMTK headers
# DCMTK_LIBRARIES        List of libraries to link against when using DCMTK
# DCMTK_VERSION          Version of DCMTK (e.g., 3.6.2)
# DCMTK_VERSION_NUMBER   Int version of DCMTK (e.g., 362 for 3.6.2)

include (FindPackageHandleStandardArgs)
include (FindPackageMessage)

if (NOT DCMTK_FIND_QUIETLY)
    if (DCMTK_ROOT)
        message(STATUS "DCMTK path explicitly specified: ${DCMTK_ROOT}")
    endif()
    if (DCMTK_INCLUDE_PATH)
        message(STATUS "DCMTK INCLUDE_PATH explicitly specified: ${DCMTK_INCLUDE_PATH}")
    endif()
    if (DCMTK_LIBRARY_PATH)
        message(STATUS "DCMTK LIBRARY_PATH explicitly specified: ${DCMTK_LIBRARY_PATH}")
    endif()
endif ()

find_path (DCMTK_INCLUDE_DIR
    dcmtk/dcmdata/dcuid.h
    HINTS
      ${DCMTK_INCLUDE_PATH}  ENV DCMTK_INCLUDE_PATH
    DOC "The directory where DCMTK headers reside")

foreach (COMPONENT dcmimage dcmimgle dcmdata oflog ofstd iconv)
    find_library (DCMTK_${COMPONENT}_LIB ${COMPONENT}
                  HINTS
                    ${DCMTK_LIBRARY_PATH}  ENV DCMTK_LIBRARY_PATH
                  PATH_SUFFIXES lib lib64
                  )
    if (DCMTK_${COMPONENT}_LIB)
        set (DCMTK_LIBRARIES ${DCMTK_LIBRARIES} ${DCMTK_${COMPONENT}_LIB})
    endif ()
endforeach()

if (DCMTK_INCLUDE_DIR AND EXISTS "${DCMTK_INCLUDE_DIR}/dcmtk/config/osconfig.h")
    file(STRINGS "${DCMTK_INCLUDE_DIR}/dcmtk/config/osconfig.h" TMP REGEX "^#define PACKAGE_VERSION[ \t].*$")
    string(REGEX MATCHALL "[0-9.]+" DCMTK_VERSION ${TMP})
    file(STRINGS "${DCMTK_INCLUDE_DIR}/dcmtk/config/osconfig.h" TMP REGEX "^#define PACKAGE_VERSION_NUMBER[ \t].*$")
    string(REGEX MATCHALL "[0-9.]+" DCMTK_VERSION_NUMBER ${TMP})
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (DCMTK
    REQUIRED_VARS   DCMTK_INCLUDE_DIR DCMTK_LIBRARIES
    VERSION_VAR     DCMTK_VERSION
    )

if (DCMTK_FOUND)
    set(DCMTK_INCLUDES "${DCMTK_INCLUDE_DIR}")
endif()

mark_as_advanced (
    DCMTK_INCLUDE_DIR
    DCMTK_LIBRARIES
    DCMTK_VERSION
    DCMTK_VERSION_NUMBER
    )
