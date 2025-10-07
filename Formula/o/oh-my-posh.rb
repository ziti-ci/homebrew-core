class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.1.2.tar.gz"
  sha256 "8555aa3af1d0efa5e8510774f8d51580247349c0efd595cf4045a218543a148e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49269c826640e6a534e383918f0fdad5da302192398bb8cfc95a13d70289bca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67cff050b0b02e202e1ff462c6ddd11beee220873359b83cd3580375da45cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2456de71ba7216312a922fc87add838c1dde387246e80c2ed15a360eaff57577"
    sha256 cellar: :any_skip_relocation, sonoma:        "4052c308d09b8ec5fbaf32df610858176f4212fd327116545115b152b3be5074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823af15895c038e8ab122d6e5ff8e75d2c933fd8ec4cb30f7bc42cbafbcfcd89"
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
