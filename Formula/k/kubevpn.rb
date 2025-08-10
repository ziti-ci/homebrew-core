class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "eef2bdbea8a23cb4bf75812273603afbfb2e5fe79246ee3b957f21c6b45e7395"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650156f018b2578088a2749106fc8cf32bf3846d910e4a815ec5e38f7fb012c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a602639dc167515153f0fff7ec498fccaf3b39fb42be343e5c5dc1978aabdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "173214cfe55e7d577dab2ebad4c3314f31b10b22087e3cf1bac2d292f61fb21a"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb76a7940130758905b78b2016f753b94522a47a9fe50701c0ad25f1092f041"
    sha256 cellar: :any_skip_relocation, ventura:       "19ba4f53e4d61da18d0120c8af657645c52768cc64377110d8dd2a0794cc49ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6f4a03898e27dee6f0e2464d5682c5d72ec6e7c401c61ed88e186828ac7d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8c39a979ff1aa820cd16862a596f7fa18c89015b14093cee56424c8fc12b2e"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end
