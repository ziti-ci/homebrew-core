class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.20.0.tar.gz"
  sha256 "15a1fa71996d4b1b3abced72004d4f6f49b755ba99a8d78427cc6576add6bb0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f666fc550809b0e7edfe87f6451003d62df13a68459bb6d49d7a1a5d302ab9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6342b0288feaa4d13a5632996dc105db92ba8c689279f3017aa3d704b5b1d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4534020660b0a6401f7ccf1a57097ebb76007986e7bcf5db1d9667f3f7186502"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a665dbb03eb77a05cf630fee59d07983e48af5b42bebdd56c477eb76d9f168"
    sha256 cellar: :any_skip_relocation, ventura:       "9074f03ee53e08dcbfcd6e3fc0c6cf360cbf29eb26f765370547e55d73dad44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d02e306e33062550dd5e59fc8d649be9966b00cfec4120797eeef454665a984"
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
