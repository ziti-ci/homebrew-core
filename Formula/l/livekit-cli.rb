class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "ad4710e0cb1ebe20c929e68ceb4cccc7c509fb1880268cf1c1d82af3458ae34a"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6c29e9261f435c60e7d618c28cffb50f79ed3e3a8aa6b87d0ec85d06a06ffd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61297bec25d1c9212dd420bb475b556130fdf8e910388534b484ffff1dfbf4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253fd1480226732f4f038dff2141f2560c47415ac13cbf02c04df9288b34c670"
    sha256 cellar: :any_skip_relocation, sonoma:        "49cb76391978c44d02698087f7948aab78cf0c26fc5c32db7fe8ebd0b4b0aa49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f533b634c96e70e35dd4be7a91e52bb16e075edd2b0d84b91e47e6dfd3c6cfd7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
