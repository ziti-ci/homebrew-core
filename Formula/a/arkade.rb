class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.45.tar.gz"
  sha256 "2638e9012c352fd2f3f6cca54ef5f4263067fd951faf86fa7f100436ccc4b70e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc3b4eaf647fbfc167ebecff6759a46fd34d79b6fcd7e6d67ac3e348b77107f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3b4eaf647fbfc167ebecff6759a46fd34d79b6fcd7e6d67ac3e348b77107f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc3b4eaf647fbfc167ebecff6759a46fd34d79b6fcd7e6d67ac3e348b77107f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ab1a3acbcceecc180381944529c64426c71a6c78b642998b12a6d1748d141d"
    sha256 cellar: :any_skip_relocation, ventura:       "97ab1a3acbcceecc180381944529c64426c71a6c78b642998b12a6d1748d141d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b714d32423887682d03cf7b5617254258d745317f08987d018171134bab6215"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
