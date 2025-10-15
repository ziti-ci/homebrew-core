class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4c70e0cf3a450b509c773b113bf21bc62ed228873bd45030b3359d391e3b188a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85be54bf201ca92bf50cf958310afe006f7534df6405d081175b18fdb64e452a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1659211605d243bd3b11615a35b1ecebe30ea636964e2a49a9be9249546b9a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0bdb621199b0bb673765f018ec85bb759cfb5f847163d1f54336b8c2b3cdae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "365593febe47b04e5347cc9b3ba4525292d7f7da24480b057f7842e93f843bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0bfc1a4b9df236a37982fd40990814afa20985463009857a42edd2270e84fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d44630b28af8068c15c037ac324af5a5edadefe2e796352e91b570e36e43ba1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
