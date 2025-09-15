class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.11.0.tar.gz"
  sha256 "278bbdf2e197f6f80a838e09574e8a950de535f0ba0f53154d26930a3adfaaa6"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87cfe6646aa8dd571c5c19f51af124ef9515fae6090acf7952481aa1d0190c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90e4b3e7fbebe0214ae29c379b4b8b6fd5e8a7f37ae470e7b6e30532673eef9"
    sha256 cellar: :any_skip_relocation, ventura:       "f90e4b3e7fbebe0214ae29c379b4b8b6fd5e8a7f37ae470e7b6e30532673eef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c4fbefda1ec421462275236ca561d2166d334f9cb6c36a66328a41f2eb720a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"tea", "completion")
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/tea pulls", 1)
      No gitea login configured. To start using tea, first run
        tea login add
      and then run your command again.
    EOS
  end
end
