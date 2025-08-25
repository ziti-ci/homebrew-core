class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.0.tar.gz"
  sha256 "bcf1a75904b14ce40ac003dea901852412d0ed818af799e403e3da15a6528b29"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2da269d6667b257d74b4b5edcfb1721c9ff479c62a337a3fe8ad23d3d666fa94"
    sha256 cellar: :any,                 arm64_sonoma:  "972c1df5c65ef35f8f9a17258705adbac04ab40861758bd3e5f7f1f0c99e41a5"
    sha256 cellar: :any,                 arm64_ventura: "3dc07732507dec611eb2d07e3112a5be3fe77e03d4fb445410db13c99133c3aa"
    sha256 cellar: :any,                 sonoma:        "b4c78a5e729c77575ab953e3b45a478c0d779072cce88120131a3ca3dae19935"
    sha256 cellar: :any,                 ventura:       "24eeaf4d8acf6640c3580259587ffe525f215b447021f710d0594a7050ce979e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01e813e07fbb1d770c8a97154addb6b6aa99c1b00ae580f1ebb705deaaca2e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48eb8b91cb253b7ae54796c5e4191fe595b7df9aaf94dcd2d5e58d03230f412c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf@29"
  depends_on "protoc-gen-js"

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      message TestResult {
        bool passed = 1;
      }
      service TestService {
        rpc RunTest(Test) returns (TestResult);
      }
    PROTO
    protoc = Formula["protobuf@29"].bin/"protoc"
    system protoc, "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                   "--js_out=import_style=commonjs:.",
                   "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    (testpath/"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    TYPESCRIPT
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@types/google-protobuf"
    # Specify including lib for `tsc` since `es6` is required for `@types/google-protobuf`.
    system "tsc", "--lib", "es6", "test.ts"
  end
end
