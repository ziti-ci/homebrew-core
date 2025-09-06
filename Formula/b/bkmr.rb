class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.2.5.tar.gz"
  sha256 "cbf076fe31c70ccc279a1b2bf776fa44e331a0ca1fef348803649d6e278c64e6"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883d8222675497e2300e7893a3b206dcb14c379949e25053c6e29727beb02a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c0b4477ec2441e6fd65f94056b4b604b00f79ea63e0e5d3dab0da5f7d490ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83304a3e92d7f8c96ae9dba146c306526f71af06d11181c1cd40a0c4d870128e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef8a5591bc709bdcaccd50fa2fe576c2a1fa903f8a1e3724445a188c56f79f5"
    sha256 cellar: :any_skip_relocation, ventura:       "ac590dea960395bb4652ae267318f0a00bf8bf2551058614cd5cd0c70dc361ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c50ba179c7058ac04a67eab4a265b50c73652d82eb770c769713ea3fff65da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626598d18c177448e8f02874409e97a9af845716e0f370251773efb9c4680008"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
