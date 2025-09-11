class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.1.tar.gz"
  sha256 "d7f8a6b28c033317c5bc4b9cda45587972b20ccc7f5335cb18262ea7e2d273d2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118536ae2b42e465f06cecbdac8bb7915553179c7af28fa46e911f21f878eb65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac671c1613555a800a3ccd4576d7efb420103b678f2a84edfe8f8b33f1a7bba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ca3d8abcb36e1dfaa0f27d4deecd4c367b9e48da3aca23b810e593bf4bb1199"
    sha256 cellar: :any_skip_relocation, sonoma:        "be97d4793b192b2ffc6434baf7ed67c73e0eeb3545c9a979cb1ccc042700d84c"
    sha256 cellar: :any_skip_relocation, ventura:       "96f79f5863df803127eb37f3b1647af8ad93731cf5a393192c91e1f5be61db67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8562d7e092c4152ffafd2d61ddf535f77a06e6b80134335b47f213d9ba915dc7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
