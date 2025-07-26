class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "6d7892f7a9e7fcce0e9a070099806a90daac9a6240da09f78728a40a196e0fb0"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2065723c8210b4c43a2071d3eb8476a00f03e41b0a1a8ed00f314958169c98f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34512f7df2f8ee01ab9504d71718a3f3f91336a780d55ca0d23f9dc780bba7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d50fbe1c137c53ad7acaf6cfc79e774b949aaca15739959f4fa87dc4a7ae8d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c9efd59300714b8b6190a7521799464db87d43671842859e0f0e6f2e66846e"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a527042c301018a039a8040e0c44f016a4b8c90ec4fa18cd8be0db547d96aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e23d107705fec2fdde5bd43ed8969248730a30469c8bca63bc6a900dc3e3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d9b3d2ffe43636b1a423efefb9784b9a37de3db755209b4a20cbf3477e1ebe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
