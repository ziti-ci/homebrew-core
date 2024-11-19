class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  sha256 "f2edf77126a75b0ec1ad166772be058351cea3d74448be7e2cef20050c0f98ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82b1a0dea57a3a31212c4276544e531efba46f7d19b45a9fc0b99a0b4a68c9d0"
    sha256 cellar: :any,                 arm64_sonoma:  "ea66a997dbb67c668b2efeefc6c55d99bb18eba228107a80ca62eab4c0e6d616"
    sha256 cellar: :any,                 arm64_ventura: "cb8df69dec1f3fd1fc81b92439e5f790f5d0b9b15c813c09fd67d2bce97faea8"
    sha256 cellar: :any,                 sonoma:        "1e6a8d749991317610e3b6ea1138a8e4d76d900a3aa705b5367cae864b2ee5b4"
    sha256 cellar: :any,                 ventura:       "bff702fbaa5e5d3804c890b944ae5f89466adab8cc589b6d69242f128bd9680f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9031c2d1bff4c0f2ceb59ae01efd28e0a983fd7d49eb8ab7a0e0dfbb4f8e1293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b869f1c4d9cb66d3cc15dbdb24ca17ad431d457807bfc7dab3aca7fe3015831"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fmt" # needed for headers

  # Fix compatibility for `fmt` version 11 and remove fetch_content
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 19059a4..6b198db 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -82,15 +82,7 @@ endif ()
 find_package (Boost 1.38 REQUIRED
     COMPONENTS filesystem iostreams program_options regex system)
 
-include(FetchContent)
-FetchContent_Declare(
-        fmt
-        GIT_REPOSITORY  https://github.com/fmtlib/fmt.git
-        GIT_TAG         10.2.1
-        GIT_PROGRESS    TRUE
-        USES_TERMINAL_DOWNLOAD TRUE
-)
-FetchContent_MakeAvailable(fmt)
+find_package(fmt REQUIRED)
 
 find_package(Snappy)
 if (SNAPPY_FOUND)
diff --git a/include/avro/Node.hh b/include/avro/Node.hh
index f76078b..7226d05 100644
--- a/include/avro/Node.hh
+++ b/include/avro/Node.hh
@@ -219,7 +219,7 @@ inline std::ostream &operator<<(std::ostream &os, const avro::Node &n) {
 template<>
 struct fmt::formatter<avro::Name> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(const avro::Name &n, FormatContext &ctx) {
+    auto format(const avro::Name &n, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(n.fullname(), ctx);
     }
 };
diff --git a/include/avro/Types.hh b/include/avro/Types.hh
index 84a3397..c0533f3 100644
--- a/include/avro/Types.hh
+++ b/include/avro/Types.hh
@@ -113,7 +113,7 @@ std::ostream &operator<<(std::ostream &os, const Null &null);
 template<>
 struct fmt::formatter<avro::Type> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(avro::Type t, FormatContext &ctx) {
+    auto format(avro::Type t, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(avro::toString(t), ctx);
     }
 };
