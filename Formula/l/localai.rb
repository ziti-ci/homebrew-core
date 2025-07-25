class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "9bdf68d1da47fd3b40d30e433b2be92343b20f8dd8f239631a0b0afc67dee45c"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfcf2439be77a5982e3809e249d6b7d9be6b28aec2a1a2b106b8c2d32c04b021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4723fd5eeb93fff39ae64277a6cbc137242cbfdfb8c59c6128cc620b71afdf85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1ae790b106209b979deb09afb86cf6a37e40d1265e468d17aa04c8fad24ef13"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe3e6af758fc3d25ce5aa3a95e7c9930bfff70acd9add7401ca1218593c1cab"
    sha256 cellar: :any_skip_relocation, ventura:       "9c7421a0b959696ad53a577500def5d7a68edab599e1f8f89a90e237aeaf30c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72c3d63868144f1d65934cb2444e688b56f52241880bfbe717d87a81b0cf5c9"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "go-rice" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/90/c8/bca79cb8c14bb63027831039919c801db9f593c7504c09433934f5dff6a4/grpcio_tools-1.74.0.tar.gz"
    sha256 "88ab9eb18b6ac1b4872add6b394073bd8d44eee7c32e4dc60a022e25ffaffb95"
  end

  def python3
    which("python3.13")
  end

  def install
    # Fix to CMake Error at encodec.cpp/ggml/CMakeLists.txt:1 (cmake_minimum_required):
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
