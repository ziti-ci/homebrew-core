class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "0410c86e8d12b29580119b1d3b45441bbfbd81782788b53ba95cfcb02e7e0da4"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b99bf93d707683349e54ea48d1b89405c71ec1d70ae92ed3b4384ac84403007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7248fc26f60b696c298de1523a1c5e52b0384358e86e8b08f314d76a30e64059"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bec3cde99c13f9b2b355b4d89a343dddefb5deb12345486615afa7d7a17739cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "252a4b4259e770532c7a77963c2dfa59e353888cd42502fd8e6e1f371bc46343"
    sha256 cellar: :any_skip_relocation, ventura:       "f2be121b276b9ddc69dfcc5c05f258c74598d9e2ad5ea5effcaaa5d7b57fd0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0ed76dc02817e6cc5815d40d1ad0ed40d71828c6fcf64866e65aa0fab90277"
  end

  depends_on "go" => :build

  # skip kubeconfig for utility commands, upstream pr ref, https://github.com/yonahd/kor/pull/457
  patch do
    url "https://github.com/yonahd/kor/commit/42443ecf76e840b4d80dc9be5c13fd1ddac54c9c.patch?full_index=1"
    sha256 "6b8d47f047e16a7fd2a99036c67c8b40dfb47242078fd657726787c382388c69"
  end

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kor version")

    (testpath/"mock-kubeconfig").write <<~YAML
      apiVersion: v1
      clusters:
        - cluster:
            server: https://mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUser/mock-server:6443
          name: default/mock-server:6443/mockUser
      current-context: default/mock-server:6443/mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:admin/mock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    YAML

    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
