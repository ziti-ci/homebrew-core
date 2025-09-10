class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.22.1.tar.gz"
  sha256 "67badbe6b5035dcd23812a510e47ac220f558e8311d45434b4f53964ba24ec50"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ad0c2a81589b919cdf6889413e25afe997afe9dbf59b9ef29c091bdd5c18799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eba34d680f839dd22f469a2ea120f67dbec8f4fcd5795268cfc1843cdd2c8e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "591b8ea43dddf1854455da7af1b798ae342fff2bc2b4a5b22fb001c458121acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a680d1a4163f2e5fcbca577da06a92955b8da9822bb76ff5dcde400f5f7624c9"
    sha256 cellar: :any_skip_relocation, ventura:       "2f5e95a463abda1663e4836d399c5be777b313881937f5ba318136c394049fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01fab76377661799ae0af6decf0e738729901a15dfb0317a237e555451d39b3e"
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
