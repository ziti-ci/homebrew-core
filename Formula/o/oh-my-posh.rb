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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ebd20012f468428c01968d0465897e52fd538a425d23262e416515fc03c2df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08542726bc92c3369a3fb784f12030fbba65c0bf40c8efbcfe9fa32a45b0b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8734817bbfd69ed20d21701a927fe2501ffe59515f523a658a6c52c06c0a074"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc172a6aaee0f25a55de74f5ea9cf598c99cefea71e5709d72ad0bb7c726a4f4"
    sha256 cellar: :any_skip_relocation, ventura:       "e01b4d7fa2a4fe33170d9ea7a72076a1950703e40f8499e03780d66d08bb2bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25b161c909d470de823fca529d9ec7a43859d2a3e73e504398db33ce0c08f41"
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
