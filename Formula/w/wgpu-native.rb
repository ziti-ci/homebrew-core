class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v25.0.2.1",
      revision: "af9074edf144efe4f1432b2e42c477429c4964c1"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  depends_on "rust" => :build
  depends_on "cmake" => :test
  depends_on "ninja" => :test
  uses_from_macos "llvm" => :build

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.linux?
    # Not using `cargo install` because wgpu-native doesn't ship binaries
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release", "--locked"

    # Manually install artifacts
    include.install "ffi/webgpu-headers/webgpu.h"
    include.install "ffi/wgpu.h"
    (include/"webgpu-headers").install_symlink "../webgpu.h" => "webgpu.h"

    lib.install "target/release/#{shared_library("libwgpu_native")}"
    lib.install "target/release/libwgpu_native.a"

    # Install examples for sake of testing
    rm_r "examples/vendor"
    inreplace "examples/CMakeLists.txt", "add_subdirectory(vendor/glfw)", ""
    pkgshare.install "examples"
  end

  test do
    system "cmake", "-G", "Ninja",
           "-S", pkgshare/"examples",
           "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build", "--target", "compute"
    # Running the built example fails in CI.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && (OS.linux? || Hardware::CPU.intel?)

    cp pkgshare/"examples/compute/shader.wgsl", "."
    assert_match "times: [0, 1, 7, 2]", shell_output("./build/compute/compute")
  end
end
