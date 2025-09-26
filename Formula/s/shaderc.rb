class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.4.tar.gz"
    sha256 "8a89fb6612ace8954470aae004623374a8fc8b7a34a4277bee5527173b064faf"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "d213562e35573012b6348b2d584457c3704ac09b"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "01e0577914a75a2569c846778c2f93aa8e6feddd"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "19042c8921f35f7bec56b9e5c96c5f5691588ca8"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9aa15de4ab68f1e5fe85d086e6930faa4eeaab80ba2ce4bf0ab0f2ad53d9483e"
    sha256 cellar: :any,                 arm64_sequoia: "45d6afe8db7c6f5fd474d0197aad4cf53c1995db94fecf06be9f001b643a2bea"
    sha256 cellar: :any,                 arm64_sonoma:  "9e80cb11cdaaf83b596865e0bec483064b176561ec565d6c07bfcdaf75def134"
    sha256 cellar: :any,                 arm64_ventura: "9fbdda4c4302bfc05c5488241a589552af047948afae1024e605f44b579d7066"
    sha256 cellar: :any,                 sonoma:        "2974d91663843a12a3c1e14d3135dab3579ed89a378f1b327844bbbbcb5126a1"
    sha256 cellar: :any,                 ventura:       "6c1b78bb709695bcb96d219826fa544f92f7057caacfb22f823299f078fc40f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "352c27770df628c5af02c00ac085fb1094e4c91ea7f41db20546d85fed02984e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d8f7856920766b54b07cc91e1a2c0af700cbb67f23ba45b5bcb9fa3af3d38a"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https://github.com/google/shaderc/issues/1413
  patch :DATA

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
                    "-DSKIP_GOOGLETEST_INSTALL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end

__END__
diff --git a/third_party/CMakeLists.txt b/third_party/CMakeLists.txt
index d44f62a..dffac6a 100644
--- a/third_party/CMakeLists.txt
+++ b/third_party/CMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)
