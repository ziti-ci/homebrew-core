class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.7.0.tar.gz"
  sha256 "cbae2ed775360496476fcc0b8d51a9510cdcd90d6f1ee7fb3f073767ba79b408"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda899508bbe0f400bb2bc9b8458913a063d10d6758ce0faa22832387b951040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "177478e59dd52ba59eb70d315c923fd9b76408e8c50281881cd0ff9a75924302"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04320cdce2d761ded726760a1523501f369b167d5bba2219d32d3d9d21eef497"
    sha256 cellar: :any_skip_relocation, sonoma:        "b772098c12ff5499ecee84c33dddb9de834e1d8b1829a7b42e44d7a8827ed13d"
    sha256 cellar: :any_skip_relocation, ventura:       "aa2b9f010b9c1f4a22d5a06bdeec04f7ad13012da43e7a9849f2a562a6f82aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10144dbe33feb80072c06d9aa629e5af237b9f6ff6fa7b70ecafe071b621f8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb4922d831f3b0e433485ffbedd36d9e121d58e0c622bb20aa39c8c79893de8"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
