class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "88aa9d67a58bafc707496aa595b52195da0ae6ae73920d40171cef58f2575fdd"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1e03bb9ee64015db5c06348f49b26be3fb56865c70935e97ae028ad99982a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1e03bb9ee64015db5c06348f49b26be3fb56865c70935e97ae028ad99982a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e1e03bb9ee64015db5c06348f49b26be3fb56865c70935e97ae028ad99982a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "227e69a10b766e77e761889610b9023d735d48509ae9c3a870efd45272c11f0f"
    sha256 cellar: :any_skip_relocation, ventura:       "227e69a10b766e77e761889610b9023d735d48509ae9c3a870efd45272c11f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227e69a10b766e77e761889610b9023d735d48509ae9c3a870efd45272c11f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227e69a10b766e77e761889610b9023d735d48509ae9c3a870efd45272c11f0f"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
