class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "1759f6e6afd282220d13ecd6f37c85840e1784f33bd3a6e775192779be9a045b"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cee73e0d5349452a3fc27575f3d934fdb25b6f068eb0e888688d5ab40b746cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5b9a897a29a34d3ef9de94c5282ce85ca43a96393b761c45187a1c4b78a9665"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4bf969eb91a1f718d44264cb91d2ff799fe447ef53b96d024f592f03057e12b"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f9da74ea2efb113308f05fc238ae7ec566c22483fa23bd98f073b1ce8f5208"
    sha256 cellar: :any_skip_relocation, ventura:       "6711f76faf42e74e61a3f10d501a7948a0afd98fc6aa7a19722bbfd320cba543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c04d2a07a3e52dd72c7ba9adbb2fc247d027e73308424173ac8df1686eccd6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423c8696277baf18a430e9061c76424c1c933af145c55b44bbc0da0636d4a3e4"
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
