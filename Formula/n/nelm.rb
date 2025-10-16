class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "a084734d4d7624f6334b0681a5ba676a328f2d2270268ddb4eab80ed5e2977aa"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f4b2552238a1553cfc86ca81324fe9320680a11232c0557a4f1d635cd263ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f05e934fc6d0967ac7e3ee4136baaa18c806c26a6e67ff2bdf868d69a68ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9837bfec784dca6beca864b42e7a75ba89b3910a69f01e0d882bbbd8b4a5f3cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "80758387bae101ae28f971e2215158d500e6ef427309efda808966f69d971db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b15364b36cae1daa0665f35b0c4696c30b92aad60c9ca0d125904f3e0c4d668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759c6753717301a0a1f5689bdf1af65f4c0ab7855cbbc2d721a72390d2620c68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
