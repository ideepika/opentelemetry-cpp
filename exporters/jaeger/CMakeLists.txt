include_directories(thrift-gen)

find_package(Thrift REQUIRED)
# vcpkg config recipe points to THRIFT_INCLUDE_DIR=...\thrift . Ensure that the
# include dir for thrift-gen code is 1 level-up from that:
include_directories(SYSTEM ${THRIFT_INCLUDE_DIR}/..)

set(JAEGER_THRIFT_GENCPP_SOURCES
    thrift-gen/Agent.cpp thrift-gen/jaeger_types.cpp thrift-gen/Collector.cpp
    thrift-gen/zipkincore_types.cpp)

set(JAEGER_EXPORTER_SOURCES
    src/jaeger_exporter.cc
    src/thrift_sender.cc
    src/udp_transport.cc
    src/recordable.cc
    src/TUDPTransport.cc
    src/http_transport.cc
    src/THttpTransport.cc)

add_library(opentelemetry_exporter_jaeger_trace ${JAEGER_EXPORTER_SOURCES}
                                                ${JAEGER_THRIFT_GENCPP_SOURCES})

set_target_properties(opentelemetry_exporter_jaeger_trace
                      PROPERTIES EXPORT_NAME jaeger_trace_exporter)

target_include_directories(
  opentelemetry_exporter_jaeger_trace
  PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
         "$<INSTALL_INTERFACE:include>")

target_link_libraries(
  opentelemetry_exporter_jaeger_trace
  PUBLIC opentelemetry_resources http_client_curl
  PRIVATE thrift::thrift)

if(MSVC)
  target_compile_definitions(opentelemetry_exporter_jaeger_trace
                             PUBLIC NOMINMAX)
  if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(opentelemetry_exporter_jaeger_trace
                               PUBLIC THRIFT_STATIC_DEFINE)
  endif()
endif()

install(
  TARGETS opentelemetry_exporter_jaeger_trace
  EXPORT "${PROJECT_NAME}-target"
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(
  DIRECTORY include/opentelemetry/exporters/jaeger
  DESTINATION include/opentelemetry/exporters/
  FILES_MATCHING
  PATTERN "*.h"
  PATTERN "recordable.h" EXCLUDE)

if(BUILD_TESTING)
  add_executable(jaeger_recordable_test test/jaeger_recordable_test.cc)
  target_link_libraries(
    jaeger_recordable_test ${GTEST_BOTH_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT}
    opentelemetry_exporter_jaeger_trace)

  gtest_add_tests(
    TARGET jaeger_recordable_test
    TEST_PREFIX exporter.
    TEST_LIST jaeger_recordable_test)
endif() # BUILD_TESTING
