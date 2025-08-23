class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "e419077c9d8ad8df0f129aecf3c36b10471ccbd9dda1f8be71ef5901050f5d7d"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df879cb91c9afc0f19d2ff49812eed28b81f8a7cc7a28b9540d453c02a0d8e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2de4c5c50aef3f4655c81a49572c2d82fbbd194222505624b5bc3ee76611069"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9543a5219d9e0622bec0e47eb88d5725e7057a1c5429615b83c7fc8951d3b25c"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b41865466b0dbb9eb461de89ea70b1765e30bf021a7ca5f993170d73c0ab89"
    sha256 cellar: :any_skip_relocation, ventura:       "befe4e0915f3eab82ef5b4b00b7f4e5a33335c3ae9f635718f11b824f9f1c563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11a326ee8695159a5c662c91d44528cae144cc5c13fb74efc7d69f9e59ab837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9533f796ce001e3ccc631865fb4c6f8c74074510c9a61d1b15142539fb367e1f"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
