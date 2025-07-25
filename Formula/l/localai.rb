class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "b9403986568d46583a0238bc2d8888cde307bb24d5f439c0e2ee897bbc055781"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbcffdcd71c8fc5d77e254efa8b3e0ed8c76c730b15773b868fe098728a7419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bc5cfee1c70a8014847dc192dd66ffc2d67de7d0aa85184ff60cf9218633c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33e12f490c14afd035409fcd12ab2366325d041ac55dd8e652cb81e70e47e45a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9efa72f47857f79a27ae0571a62add1a322f502717bf26ebd8fcc80000366ca"
    sha256 cellar: :any_skip_relocation, ventura:       "e10edeacad08ae138c77c65e9137e55950e71eb499dfb1721802c23605de0f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602bf616367f923db321cc5e41f134628ac68310447231f6e87156edc25d7804"
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
