class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on macOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "116c0064ef15bccd358cc067ed52fefc745c6108854c6516d74c8c77a1ed437f"
  license "MIT"
  head "https://github.com/philocalyst/infat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb21d73fc3a0d89b740e707234155e190859f405b9de50de941bf39b1f998138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487af8bcfabe8af822b6367ffcf8b6cc5aa1d83e0a0104313a896820e004ff1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3deb35e4da718165af86cff9d406c52a17c9a4c35b859807b54c8d63201fdc69"
    sha256 cellar: :any_skip_relocation, sonoma:        "52960a48888a9c5b9df70a19f9de34acf3272946f91cf6dce75fee185cd67fc0"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "infat-cli")

    bash_completion.install "target/release/infat.bash"
    fish_completion.install "target/release/infat.fish"
    zsh_completion.install "target/release/_infat"
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Set .txt", output
  end
end
