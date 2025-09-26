class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on macOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "c931cc909c98cabe24e6ee92f10e9fc45941499f4e07e4f201bcc6c9aa910a7d"
  license "MIT"
  head "https://github.com/philocalyst/infat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcef3e55402d5c8e016cea110df4d04aaa304dec6f4d359d4983c677cd6b51cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdaf5db6b238753ccc890899bc4531755c51e71076fe26d7654973972f4f31e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0031bf440b8167044dd615171095001aad021afb0590e2f179612a0e8bcc9520"
    sha256 cellar: :any_skip_relocation, sonoma:        "e684dc96c078f68dd52cc15e1145789168bd7c4ee3fb4f245a56f3d664d41c6a"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "infat-cli")

    bash_completion.install "target/release/infat.bash"
    fish_completion.install "target/release/infat.fish"
    zsh_completion.install "target/release/_infat"
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Set .txt", output
  end
end
