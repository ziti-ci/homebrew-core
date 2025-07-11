class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "1d9322296b8fb0c789ad3a3b13284f39e15a55efb479b3d2e2d5954ec3c0ea73"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2920ef30f1197c7a50568527d83302ae5db880c64de74eae29f8fb75b83ff6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed17a14f566ea783dd2335ef4ba02ec44e98ace9787983399ca328539a2cd7ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2644917e6d9ffa26b325f8c1b54fdb818a0ccea7f8fd0c844dec722019a7fc8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5c8787728465fc39e4f8ec1c73ae91b0afb435a51bce2f076490deaaf08552"
    sha256 cellar: :any_skip_relocation, ventura:       "60371e8fab13832cfeb8ba9e49a8aede4c11d62d005a517ccf62d56ed094e23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a300ba03230b9870de74ce592100eaf04d81327596e4a7b4f972b2dbebbebeb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50c57ce140ac2501ed43757382650dd4c4d6bcc05ecd1df808e04f84d20be36f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
