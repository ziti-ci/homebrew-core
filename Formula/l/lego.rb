class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.25.1.tar.gz"
  sha256 "8c85fd4e4bafcb57db51ba381d5423b1bdcf0737208981d21f51fda7c632a132"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3338864c24b4861f1da8d2d0b58617b9aa199e625ca8d2bfb2330fdc69d1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e3338864c24b4861f1da8d2d0b58617b9aa199e625ca8d2bfb2330fdc69d1cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e3338864c24b4861f1da8d2d0b58617b9aa199e625ca8d2bfb2330fdc69d1cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "28864b441a4298f20f22f3728aea2db934a6e00a944a73b0448f2b0f36fa5efb"
    sha256 cellar: :any_skip_relocation, ventura:       "28864b441a4298f20f22f3728aea2db934a6e00a944a73b0448f2b0f36fa5efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6a944a58d012002b4ede432b72ec1a45f035b7c87bd2c123b5e671665783ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
