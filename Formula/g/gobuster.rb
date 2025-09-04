class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "6919232eafbd0c4bbc9664d7f434b6a8d82133aa09f1400341ef6985ceff208a"
  license "Apache-2.0"
  head "https://github.com/OJ/gobuster.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef43cf91c4fcca6e0e17328f29f8949fe3f35f868277d893fed0c1f84c6749f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef43cf91c4fcca6e0e17328f29f8949fe3f35f868277d893fed0c1f84c6749f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ef43cf91c4fcca6e0e17328f29f8949fe3f35f868277d893fed0c1f84c6749f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6943c5bfbb03390266b87e0d0eb0ef1b2a46e1484f6b24cb4f1662abd260589"
    sha256 cellar: :any_skip_relocation, ventura:       "c6943c5bfbb03390266b87e0d0eb0ef1b2a46e1484f6b24cb4f1662abd260589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68ad8266129a888db2ba56be5378d402bcc846533311d2001537a566d91e016"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output("#{bin}/gobuster --version")
  end
end
