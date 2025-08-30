class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "1fb72b9710beb74c2a66978f7dd68d69723bcbae8dc3368cd4b2262d50c19cf7"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565156fbb8ec538e1f4148e5e5e9ef4b67b3bdc1b9bcd8e07b23f838b0a23af6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7687fa06a742c28f7a43003395e47db93befa15f73e8471e2d8f70e701b0605b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17fe58547bb0c009cf5f4c9a1363f5709796c74d75ab1f48483c665377bd54cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8189547b836afb48104081b95ce975168d393b8092676a9dc91702f64a92f2"
    sha256 cellar: :any_skip_relocation, ventura:       "8f905b456e43330443af07a66013e0029cba85863631fb52bc638f1d5c3ecf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86dd13f863ac914be85af84132888bad4bd4147ba6bd4e5d3233546fa376bab"
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
