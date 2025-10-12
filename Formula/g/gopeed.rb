class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "61750c024e9a1e476ced472427ab77158deccdc756b5478b3ca72a3705a23fe8"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "073b6b7a3ac3903de2faf00f6d399e0ff2187839fe80a7eeec2377afafd4b54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ad22fac255dda845e4800087d723d4f7fcdb5c4c2d5080cc1953438ed9b7c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa967719956a0c2f753268174f91bbe4d97834418912d6b43dab4897defdf1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5fd0a801f6e12e3556bc0803190384bf897f9e25e8fe3b5509254d6fff7e55b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a1a259ad0f09c9f859c531327214e4d666fc8658ef3491e2750c081dfb69ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0921d37dc30ef1fb2ac2b113c80b3452a7c28d0529aecbfaa57299cdb8262d8b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
