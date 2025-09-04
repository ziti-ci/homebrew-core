class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.2",
      revision: "791b036d983452402ed4aa0c96a7a9d47842871c"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3bf3ff245200f69010304838bb88d67e134271525475131be39e04a4ae4700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9952899d7d87a354d88e4707737f62abd99d8396fab020fc4a1630fdd50c0409"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3cc1cd7c74fef346e45ab801749d317249d6c8d2d21441a05558f0a62af6bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e1256be74fdf4ade63de9318e15d29645fd7b687a13c0e0a7a14f2882a3be37"
    sha256 cellar: :any_skip_relocation, ventura:       "c368656579cf6d2123314b599dcede34de74514e00383c6f315fa4a703d6b4e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b02aaac50b4393566bf71522f8e50be1d32f974593318da5f5c34ef59f374ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f559ec13cb79a8b436e1b5551cc521baed5eeb50da41a6c096435fd242fab81b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
