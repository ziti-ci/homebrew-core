class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.24.0.tar.gz"
  sha256 "01d9b9cefa70c99797a531b6c889291b90fef7201050554b5734c670c3290ff8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c63fca7a738e8c25744ecfbfb42e16c137cb5438be3ba0974fef640811d80991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93850d55c20bb9ccce750dd5edba42949db97797348ad26a28676d46d655b41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e6c253b0af57620d476069d02f4bc70fc25d4923cdb97b8ea53f17f4561fcd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "91bfb1142554cb95a64c5ea52bda214acad7201c4aaa3c29654dbc0f33273a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63025e497a1e495870814dc918c64340523e430be60ba3d0510aa6f7f2d68246"
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
