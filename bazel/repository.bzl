load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def opentelemetry_cpp_deps():
    """Loads dependencies need to compile the opentelemetry-cpp library."""

    # Google Benchmark library.
    # Only needed for benchmarks, not to build the OpenTelemetry library.
    maybe(
        http_archive,
        name = "com_github_google_benchmark",
        sha256 = "dccbdab796baa1043f04982147e67bb6e118fe610da2c65f88912d73987e700c",
        strip_prefix = "benchmark-1.5.2",
        urls = [
            "https://github.com/google/benchmark/archive/v1.5.2.tar.gz",
        ],
    )

    # GoogleTest framework.
    # Only needed for tests, not to build the OpenTelemetry library.
    maybe(
        http_archive,
        name = "com_google_googletest",
        sha256 = "a03a7b24b3a0766dc823c9008dd32c56a1183889c04f084653266af22289ab0c",
        strip_prefix = "googletest-a6dfd3aca7f2f91f95fc7ab650c95a48420d513d",
        urls = [
            "https://github.com/google/googletest/archive/a6dfd3aca7f2f91f95fc7ab650c95a48420d513d.tar.gz",
        ],
    )

    # Load gRPC dependency
    maybe(
        http_archive,
        name = "com_github_grpc_grpc_legacy",
        sha256 = "024118069912358e60722a2b7e507e9c3b51eeaeee06e2dd9d95d9c16f6639ec",
        strip_prefix = "grpc-1.39.1",
        urls = [
            "https://github.com/grpc/grpc/archive/v1.39.1.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_grpc_grpc",
        sha256 = "024118069912358e60722a2b7e507e9c3b51eeaeee06e2dd9d95d9c16f6639ec",
        strip_prefix = "grpc-1.39.1",
        urls = [
            "https://github.com/grpc/grpc/archive/v1.39.1.tar.gz",
        ],
    )

    # OTLP Protocol definition
    maybe(
        http_archive,
        name = "com_github_opentelemetry_proto",
        build_file = "@io_opentelemetry_cpp//bazel:opentelemetry_proto.BUILD",
        sha256 = "9ec38ab51eedbd7601979b0eda962cf37bc8a4dc35fcef604801e463f01dcc00",
        strip_prefix = "opentelemetry-proto-0.9.0",
        urls = [
            "https://github.com/open-telemetry/opentelemetry-proto/archive/v0.9.0.tar.gz",
        ],
    )

    # JSON library
    maybe(
        http_archive,
        name = "github_nlohmann_json",
        build_file = "@io_opentelemetry_cpp//bazel:nlohmann_json.BUILD",
        sha256 = "69cc88207ce91347ea530b227ff0776db82dcb8de6704e1a3d74f4841bc651cf",
        urls = [
            "https://github.com/nlohmann/json/releases/download/v3.6.1/include.zip",
        ],
    )

    # C++ Prometheus Client library.
    maybe(
        http_archive,
        name = "com_github_jupp0r_prometheus_cpp",
        sha256 = "aab4ef8342319f631969e01b8c41e355704847cbe76131cb1dd5ea1862000bda",
        strip_prefix = "prometheus-cpp-0.11.0",
        urls = [
            "https://github.com/jupp0r/prometheus-cpp/archive/v0.11.0.tar.gz",
        ],
    )

    # libcurl (optional)
    maybe(
        http_archive,
        name = "curl",
        build_file = "@//bazel:curl.BUILD",
        sha256 = "ba98332752257b47b9dea6d8c0ad25ec1745c20424f1dd3ff2c99ab59e97cf91",
        strip_prefix = "curl-7.73.0",
        urls = ["https://curl.haxx.se/download/curl-7.73.0.tar.gz"],
    )
