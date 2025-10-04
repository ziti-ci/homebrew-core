class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "8f021502ffeab1309c4c78365bb0aa18d10b326d688b7d52917be7200c987e09"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e289aa5bc417f7fdeab24fe334069f2adc6ee613339b3feb1d74d6d49b54b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e289aa5bc417f7fdeab24fe334069f2adc6ee613339b3feb1d74d6d49b54b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e289aa5bc417f7fdeab24fe334069f2adc6ee613339b3feb1d74d6d49b54b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "00460d1d3677b549c3e176c17cace53ebfddc64944c30193b4037776bcf827e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2121223b3e306c5e505d7b20fc6ddf97519d567feb5a9b9623a0e3aa12128555"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
