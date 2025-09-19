class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.13.7.tar.gz"
  sha256 "3a87136add8f7b184c5a86c1801ffb3059db2d50147eeaa640d4298df4960569"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3552b3401058763cbe4ed2f69eeebdbb4dd31e897b5e4932d025583b93a9a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265c8039821f362b28ad8fa74ce358110674de32f9ae8b9bfd802f4c550359a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea158bedb5688003829afaa663ce2309205fa1cbfe46bc85f68a68cf76365a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7913b8d1ffe6789c8d0256d77e8d01fdf6405d9cd8e8c7d05114abb6c15e31bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6a53dfe836bd42f25d6cbb6d654c3ecfed305d75eab3c514dc1e5f0ffcbdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c5f3d34a1ca925df6b8e3f0fcf6f6012336a121234c14f08208679d45ec27f"
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
