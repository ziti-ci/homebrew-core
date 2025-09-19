class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "ab95b1a02f676514fbac8367903d3ebd6f4cd09e2e84a4b99c1fa2918e07b9a5"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2a3753c6d4e1bb9e289746dca2809c8e0d89fc017677de7f772f14d2608aa34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b08d7ed021c09f681dd4d6af42d1d94f51758a2bc77beda0a3225ac3b6a78b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d01ddb86057953983a93d8954f22e5235f03c6d0010c99cc43a22a18ed3a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d1aa29c30178829878d6f59fa16fdf9fba20aa2a863d3af2b740e98bc27836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce1b549d6c899d00529fdc485f2416c57b3b3c6a9fceca4a2faf7be7276c68dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cec7b8ff8e38260f3b1dd0dbf9a26bf6de24b4eec64114b74241320e36be433"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
