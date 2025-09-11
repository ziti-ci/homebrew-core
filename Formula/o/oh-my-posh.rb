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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0115820b3799ab497c373eb00b179cf23a8bf0677edb013c10a1deb9db175e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e1cf76f19fe93a2934d8e4c3bcf3abec3da3f3501e989a8394249e57aff1e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c8aece871d75b6e2928c188aa8bc5501f73c2750c829b441c3a79087746d119"
    sha256 cellar: :any_skip_relocation, sonoma:        "c151b1de02c6001961ce28ec7297b1f1c882b1728be0e528ceb368c79cd8e470"
    sha256 cellar: :any_skip_relocation, ventura:       "1f938895108e4128ab144cb2a51831d5e42561399b1bce26aacd5e7c2f21043d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3fca470b412a28da5c8ffae0fbbbfe8ef538596b29784283280a8af9d483817"
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
