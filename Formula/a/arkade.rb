class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.46.tar.gz"
  sha256 "014d889986e57fe77daf9a8f6fabb15337db5b9156666a1e78d8a52513723102"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a08b77f82f8011bd652c2916a4be7689da50c3df2727759d31874b8e3c93b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a08b77f82f8011bd652c2916a4be7689da50c3df2727759d31874b8e3c93b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a08b77f82f8011bd652c2916a4be7689da50c3df2727759d31874b8e3c93b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f0d972cb38311100b6be6f6098ed2b040d82742771b58b52b30da1f7a0596f7"
    sha256 cellar: :any_skip_relocation, ventura:       "2f0d972cb38311100b6be6f6098ed2b040d82742771b58b52b30da1f7a0596f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd82c97566f38693f549672c150cda7b4dda6781de375602f9ccaee5d0a5e7d"
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
