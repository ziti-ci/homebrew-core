class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6040",
      revision: "66625a59a54d0a7504eda4c4e83abfcd83ba1cf8"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b6f05e2683c7d9e05c468a6302c54f171fd9a079e6d6092c78d2c5f2cc7e1e5b"
    sha256 cellar: :any,                 arm64_sonoma:  "fe65589267543e49f403ac29ba3df2e949c04254b11f3db5999a91598122f645"
    sha256 cellar: :any,                 arm64_ventura: "79a15dee8226f1a25f8215d5f916b71ecd701f09c65063f3ec47a1b4e6463976"
    sha256 cellar: :any,                 sonoma:        "9bf07a30b3c1724dd9aa412ad0c952f1ee9c972113af58b95a792e9e9f14440e"
    sha256 cellar: :any,                 ventura:       "800db1f085d4c675a6e35b4824a4df7ea1af3bf2a0ab3abe7eb3dda12b8ee102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59dc2ffd49417d5b470bcac5d9335f1a5ede8c78a1b289532a887ca970a0ca3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ed70ec7bb89b3a3b1887780c8ae1f6290c11932e814765f28c4eaa43940425"
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
