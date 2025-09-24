class Ggh < Formula
  desc "Recall your SSH sessions"
  homepage "https://github.com/byawitz/ggh"
  url "https://github.com/byawitz/ggh/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "1adf81aec62040233154843dd18cf575c9485a10d4f46c475708474536422b1b"
  license "Apache-2.0"
  head "https://github.com/byawitz/ggh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4672d45cd328ac0915aace0c2432f16754d8a49928f2953a45a568ead97ecb60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5c76f29ddf4e03a9c39f54fb7c71314821e88a59b631f9a50a0cff0e951ab79"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d982cd8c4285912f2e5d720c97e3898b346343ad933d96a2c390521c28c6db"
    sha256 cellar: :any_skip_relocation, ventura:       "38d982cd8c4285912f2e5d720c97e3898b346343ad933d96a2c390521c28c6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3aba2f8d471a9989c8645f21fe758f1d91d8e0486d0e1458005ee2cf038a9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d0469db82a510fca7534c6b614a92d7e0e23dd756a808b8e4fc4c1f0f5a9ed"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "No history found.", shell_output(bin/"ggh").chomp
    assert_match "No config found.", shell_output("#{bin}/ggh -").chomp
  end
end
