class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7abf33bde57a7a774206fa4d33ee2b4d0283c37d6764d431ea918ada39035ffb"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cadc98d013900427a7511f1094e200459d110c8a0fe03481aacba013c273b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cadc98d013900427a7511f1094e200459d110c8a0fe03481aacba013c273b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cadc98d013900427a7511f1094e200459d110c8a0fe03481aacba013c273b60"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fb5d38489c2f09a366cd138c2cf9df0b22b93a4550313714a591ce4b932821c"
    sha256 cellar: :any_skip_relocation, ventura:       "6fb5d38489c2f09a366cd138c2cf9df0b22b93a4550313714a591ce4b932821c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7417335b042839a84d0b848b1903db2c1efae6fcf1784bcbc6c6f5db434886a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
      -checklinkname=0
    ]
    # checklinkname=0 is a workaround for Go >= 1.23, see https://github.com/nxtrace/NTrace-core/issues/247
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
