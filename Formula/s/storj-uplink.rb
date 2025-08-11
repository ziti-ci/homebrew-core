class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.135.3.tar.gz"
  sha256 "ea3ae5dd3f24d4840477590d5d0d5f5f0aa8ce9d6d9fc52899ee67ef279f44db"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1421b622d75f1ec48f0b6355c9ae65dd184eb804c42414fd284c0cd9a493cc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1421b622d75f1ec48f0b6355c9ae65dd184eb804c42414fd284c0cd9a493cc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1421b622d75f1ec48f0b6355c9ae65dd184eb804c42414fd284c0cd9a493cc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "66edc40ffcbe2c05dfc46bcf56789f7139db47544ef32b19b7173c46644184b8"
    sha256 cellar: :any_skip_relocation, ventura:       "66edc40ffcbe2c05dfc46bcf56789f7139db47544ef32b19b7173c46644184b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e149efeb60f045efaf08742c8810303ae166ecfc07d7f412b2f7c194fd612262"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
