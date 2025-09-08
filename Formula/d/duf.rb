class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a81883475ab5591840882892a85185b7cda153e87f4d3978b45dec215761585c"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5923cec9d00d0a742a8637a29c6f30ee3541cec3a4293fcb55320f3cf65001db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5923cec9d00d0a742a8637a29c6f30ee3541cec3a4293fcb55320f3cf65001db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5923cec9d00d0a742a8637a29c6f30ee3541cec3a4293fcb55320f3cf65001db"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c182ae004c6d96d4aec6fa924144fe2b2f77d005cefdfb946223a633e862dc1"
    sha256 cellar: :any_skip_relocation, ventura:       "0c182ae004c6d96d4aec6fa924144fe2b2f77d005cefdfb946223a633e862dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "519c3ecacc8fcbe2f4a8037d04cc92326afeb89a10eee477fbdac4a3719441c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f5adabfdfb438f709761c44ed136c42c5a5f09951d8fa00f1ac52dbad3c099"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
