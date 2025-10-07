class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.1",
      revision: "18f981e04b092593cb12a4d6982dfd19deca758a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d684650dc22f7fd985ab59964ef7bfb678a0a2dcf721445ec34fdf841198c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7154d1f3f3f96b13d53a80db31b9a9686d48325223c4494540f289ce34848ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660e15bf065362b5ee9604156b5766d21d588c7f0254810b5309e4876d823ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f61aeb339457bb5142e2596ace227c0f8311c04a984744c5b7513138b44abe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6886245fbf1e62dadb936ee0ab21d46df9dc9e2d1ead8fc12aa53f0e3ceeee"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
