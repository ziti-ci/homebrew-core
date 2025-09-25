class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e20b39dff98c82a791ae9e5ac40ce78f6e25a5beac3ce7b4d53a3c0b45794f04"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a53e4b807b85cf00e833102650028ff9e0033dd04b61a28d4e23fdec98732f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4a53e4b807b85cf00e833102650028ff9e0033dd04b61a28d4e23fdec98732f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a53e4b807b85cf00e833102650028ff9e0033dd04b61a28d4e23fdec98732f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4a53e4b807b85cf00e833102650028ff9e0033dd04b61a28d4e23fdec98732f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d48f771f5f28f6ebcdde2751feb98855dcdae0e95d026ae72e7787309f2835"
    sha256 cellar: :any_skip_relocation, ventura:       "b9d48f771f5f28f6ebcdde2751feb98855dcdae0e95d026ae72e7787309f2835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993bf1845ac3db8067ac54af6625a966217ce79b75c5a029e214da48076d0a52"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
