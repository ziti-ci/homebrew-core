class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.165.tar.gz"
  sha256 "22668f6e7519199c73456eb40a10f4bba1a9126fc92048476e1494df5dd184c3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "070f7685a6b9c675533313f5ff27545272a82eec9d9b668f8bd87550ae4162d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "070f7685a6b9c675533313f5ff27545272a82eec9d9b668f8bd87550ae4162d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "070f7685a6b9c675533313f5ff27545272a82eec9d9b668f8bd87550ae4162d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57cfc295a20d031d8656185d1bf5da564543b20926ae0a4c90632f10eef35d7"
    sha256 cellar: :any_skip_relocation, ventura:       "d57cfc295a20d031d8656185d1bf5da564543b20926ae0a4c90632f10eef35d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8863b98901ae72fd4f69052c03d53d2b243c5dbb5b070b360f61d8bba1bf5d9f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
