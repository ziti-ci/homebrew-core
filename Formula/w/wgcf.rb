class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.29.tar.gz"
  sha256 "25bd436c3d0919c8e76a2e31806520c401c9561663946951746d4027a7fab96a"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e554bdca56ad920d3257ccb8bdac8e762f197ccaebbf9c261d775faf94bb767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e554bdca56ad920d3257ccb8bdac8e762f197ccaebbf9c261d775faf94bb767"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e554bdca56ad920d3257ccb8bdac8e762f197ccaebbf9c261d775faf94bb767"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9839c1a2ff0aef0966e3e8005fb5b58b192c00ee727036937784645c9d6f70"
    sha256 cellar: :any_skip_relocation, ventura:       "1b9839c1a2ff0aef0966e3e8005fb5b58b192c00ee727036937784645c9d6f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2616b6127e1cba816ad39ed4c28d14c25d984ca59ff59311a2e8d558de99661"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
