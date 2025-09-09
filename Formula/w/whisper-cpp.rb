class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "166140e9a6d8a36f787a2bd77f8f44dd64874f12dd8359ff7c1f4f9acb86202e"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "636c1047e486565c633ee7c8d5fe1516523455c8e0bbf411cb8c3da64bfa7bbf"
    sha256 cellar: :any,                 arm64_sonoma:  "32283223f15857d4cee69dbb2cd40d4d41628e92be3ddf0b73abc1210d03d0de"
    sha256 cellar: :any,                 arm64_ventura: "b2d967c489972e2b33e18e2f522edadb4b6c3ebf649bd3b210da2f0e11c966dc"
    sha256 cellar: :any,                 sonoma:        "0014e64387e00ca1bb880fac360591ebfda759f5734da27cda53bb22596c2688"
    sha256 cellar: :any,                 ventura:       "db5386e09a395aa027e0841dbe2c86adea1baa9afceb93a509afa8836ae97dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5afc447df4b6c96c221b734f3e5f8604430a9185b9b9549d6f6b0eb3d73359b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c39e9121a09f776b2ebe83d75541e8abd7011d0a2e8aeb620eeab5b950a4d5"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath(target: prefix/"libinternal")}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]

    # avoid installing libggml libraries to "lib" since they would conflict with llama.cpp
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: "libinternal")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # avoid publishing header files since they will conflict with llama.cpp
    rm include.glob("gg*.h")

    # for backward compatibility with existing installs
    (bin/"whisper-cpp").write <<~SHELL
      #!/bin/bash
      here="${BASH_SOURCE[0]}"
      echo "${BASH_SOURCE[0]}: warning: whisper-cpp is deprecated. Use whisper-cli instead." >&2
      exec "$(dirname "$here")/whisper-cli" "$@"
    SHELL

    pkgshare.install "models/for-tests-ggml-tiny.bin", "samples/jfk.wav"
  end

  def caveats
    <<~EOS
      whisper-cpp requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https://huggingface.co/ggerganov/whisper.cpp/tree/main
        https://ggml.ggerganov.com/
    EOS
  end

  test do
    model = pkgshare/"for-tests-ggml-tiny.bin"
    output = shell_output("#{bin}/whisper-cli --model #{model} #{pkgshare}/jfk.wav 2>&1")
    assert_match "processing '#{pkgshare}/jfk.wav' (176000 samples, 11.0 sec)", output
  end
end
