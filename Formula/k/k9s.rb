class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.12",
      revision: "09c1c0795051f443da6b75a11705e25c0c1c7c6b"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "247eab55d4ee7751b5a5785e81f1387db64e0018c0ef12822a7365067de3e0a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67454651ef8efa7f317881883953622f23a87cee78701915b33c29defece4318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57ca20846810534851c18744a67e971228303bc4139c4d0f7c74de0750b9394e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a3b01ec8ddb9361fb2f207ea6cc48845a52204df7151ba1f42fd424f4529f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484cf6ce1644db8998adcd77c2cf034191347d1ff7fba730533b1a680cdb844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad460390be1a0db5caef09023d87d1af5e89128727a4636ba18ae8ddd41bcde"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
