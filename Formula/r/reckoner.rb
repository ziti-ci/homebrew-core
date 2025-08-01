class Reckoner < Formula
  desc "Declaratively install and manage multiple Helm chart releases"
  homepage "https://github.com/FairwindsOps/reckoner"
  url "https://github.com/FairwindsOps/reckoner/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "7d43511db233739f1584c2d0875333c97a9470b4689dd2d65a36d1d591096d7a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/reckoner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94837511a2176e73a13857a65e796c789b0eab21426754d8964fa5f23a70d830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94837511a2176e73a13857a65e796c789b0eab21426754d8964fa5f23a70d830"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94837511a2176e73a13857a65e796c789b0eab21426754d8964fa5f23a70d830"
    sha256 cellar: :any_skip_relocation, sonoma:        "c306a999e8b9f99767918beaf886b698646bf0df84aaf0f84f8f2ba5be257dec"
    sha256 cellar: :any_skip_relocation, ventura:       "c306a999e8b9f99767918beaf886b698646bf0df84aaf0f84f8f2ba5be257dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "728e430d18ad959bd4722c12b93cc7f06462878e85de54d2ab069246e8326f63"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")

    generate_completions_from_executable(bin/"reckoner", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reckoner version")

    # Basic Reckoner course file
    (testpath/"course.yaml").write <<~YAML
      schema: v2
      namespace: test
      repositories:
        stable:
          url: https://charts.helm.sh/stable
      releases:
        - name: nginx
          namespace: test
          chart: stable/nginx-ingress
          version: 1.41.3
          values:
            replicaCount: 1
    YAML

    output = shell_output("#{bin}/reckoner lint #{testpath}/course.yaml 2>&1")
    assert_match "No schema validation errors found", output
  end
end
