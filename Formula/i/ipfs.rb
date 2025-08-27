class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "f5b23c8f55f356993f936a310576f89a3cb4c66f4eb0cc68c41131869acf1495"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938ac5ca4de605a7469763c5d0c415be83c7e8f9bac207f6ef8964b000cef1b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6921f2976da898f4a794440cf49f66457faf0432f6535a7c3d278bbd129aa4bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e92599a949ffbf3cbb1a802efdea1ca7d08485d308415a4b36dcc1b38af723"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3bbae0c90480e57af2c07a26a00e58310e63466ca7f50dd03fc49f529d56fa"
    sha256 cellar: :any_skip_relocation, ventura:       "1fded615964e3d2511b509db839737777d55a70fbf7e168eb74accb09a8316d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f842050ffcbce022a8a22355596e528825b5740c4c3f3f00bf108bdf20e1138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f567660e0ba645b884d36b5f5e62fb17d522057474cea8929420467c82e50252"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
