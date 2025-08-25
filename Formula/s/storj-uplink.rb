class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.136.1.tar.gz"
  sha256 "03f769b60254bb1026d0bd64a9492f16751b588d7c9c2fd1cc0c34d5f1d1a8e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed9e66d8cb90358f8a0b4c0c3bb8fcb5dc84b64adcff9d977c0ca1e4568f05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed9e66d8cb90358f8a0b4c0c3bb8fcb5dc84b64adcff9d977c0ca1e4568f05a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ed9e66d8cb90358f8a0b4c0c3bb8fcb5dc84b64adcff9d977c0ca1e4568f05a"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f134579a3ad29ecc951c8a123a7484d6094dd300a0780ff6f6815e467014a4"
    sha256 cellar: :any_skip_relocation, ventura:       "09f134579a3ad29ecc951c8a123a7484d6094dd300a0780ff6f6815e467014a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdac6f7d3ec9c9501556fe2d6e357100fd77b865736851c1b8adc019d2daee5"
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
