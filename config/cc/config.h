// FIXME: convert to bazel from cmake:

/* # For git users, attempt to generate a more useful version string */
/* if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git) */
/*   find_package(Git QUIET REQUIRED) */
/*   execute_process(COMMAND */
/*                "${GIT_EXECUTABLE}" --git-dir=${CMAKE_CURRENT_SOURCE_DIR}/.git describe --tags --match version_* */
/*            RESULT_VARIABLE */
/*                GIT_VERSION_RESULT */
/*            OUTPUT_VARIABLE */
/*                GIT_VERSION */
/*            OUTPUT_STRIP_TRAILING_WHITESPACE) */
/*   if(${GIT_VERSION_RESULT}) */
/*     message(WARNING "Error running git describe to determine version") */
/*   else() */
/*     set(PROJECT_VERSION "${PROJECT_VERSION} (${GIT_VERSION})") */
/*   endif() */
/* endif() */

/* configure_file(config.h.in config.h) */


#define PROJECT_VERSION "FIXME"
