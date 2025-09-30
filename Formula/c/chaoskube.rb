class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "ee2db89df0136c86997aa867951010e901f59273d840ed43a826d4d5fd89bd9d"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160b8d4c2cd2698c05203f2c1a88ac4d80a76947e549a8440ef42743003f0981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af07f7023810e073cd9aa80a5d80cd6993304dfbb7db52f40bd8fbb2f17baa2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a174b2900778310bd759e795fa6ebe6356fb901e03af40ec6c78ed73a631cbf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a09247af2f701fd0e0604276b804f3155e5566e179303ab131e6e03006f51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99ecd9428d82edc3c3b3505a7b608093bc04ca65893be1f698acad8d5b410a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
