class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6280",
      revision: "0fd90db5858e325358a5fbdaa4e327ee2a79d0d4"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb2b90582f527774d71bca9a2c2792094eff681f213cc303330234fdd41fb02b"
    sha256 cellar: :any,                 arm64_sonoma:  "9b0f9fe5bb36ceef26bdafa2582192b8a6686f3f7468807caccbf9b73922f545"
    sha256 cellar: :any,                 arm64_ventura: "af6a8134c047a6eec9802962577bc462ceeae8a3a6a1033845b1fb9762c54c89"
    sha256 cellar: :any,                 sonoma:        "8d7e6b1c46a92f6e51e0410ff73aefdceb12667a73073e4e83ef66126a5a4b58"
    sha256 cellar: :any,                 ventura:       "84d1fefd4e70e28e550fc55dbca5eb00bb77949462eb7c866681afd23352d75a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37e7a70528216ded58b58377859b572a13208ce3fce5964aa39cdb90516e742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40b3cd1b570d40f9b38943b6c0bf6b80be2600e9adfcc02fd37de9bebf5e6be"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
