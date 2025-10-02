class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.26.3.tar.gz"
  sha256 "e3e3c8761e724d5baf393f8e47ab211c0bcff4ef288e24cfafe881d152371bd8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21fd07ab7c9347058a19c958266df2a59507f98370e292e5fe05f699b7cde48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342ff97a53d6337b9d56fc4837a1ee291a7f887b75fc0f4e65ab3fc3d03b7e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1951fb0f89416fe7d5859fe6024b7b3e9bd977007aa3b43d667b8f8d375592"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f65dbc114d542db149e13fe24fbbe3c4934c52d7f83556c74062fa607627dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a33edb948db7f65450e72b5577e454352523114ccf21cd566212ddb497de69"
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
