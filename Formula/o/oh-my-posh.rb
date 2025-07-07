class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.14.2.tar.gz"
  sha256 "00f972018239b05b3d61b87a2d6bee7d1ec54983c21ae88a3af25ef36f53802a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df19a37f61f8c70903c04945436a823a8eeaa32b0e71e401f1e777006e25fe8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "427ef0f226982b4fe19d54de46a67072ed40d6230eae1fab876fd25162aa12a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52e12d38e5ee155e58d23b5abf7e56ec0b05b963309dfadd0a1d8ddeb24d05e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b822a2f8e8f12dc883bb7a0471761a911faade1c30c66a0832ddb08a52f312"
    sha256 cellar: :any_skip_relocation, ventura:       "5565cb8b8fbe1fc31149816d9ede1e4909dc5b6b6c02e4a97cbe18930acc68e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75ee1b2cd894b4499ccf38220f4b4a8d3fc5f6cc9afb6dfc99aba1efa768bda"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
