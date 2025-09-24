class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.25.0.tar.gz"
  sha256 "73811b8e442abcb4444142fa31a999ca4342ba2dc91b498a3f34d1138a6d010c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f02acf70e0ed744dedcaa37149a9175b6fb607b9d068b7ec38078bc9a963224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4d15988837f941edfffb64ee54e17ee65b73dbd37a0252f0a50953a8a16f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0f9c36908c140f3cf940221175d143e0c7a152ab576c656e3b24b95f0bbaca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5638d93e23f41b753ad2066a88ef9279a3a664cc3d11d0f0b693fe12fc416d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b14fc8d2b37a1ad4f0ee3afebd9683ad3b8ad922159b15ddce6075d87617cd"
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
