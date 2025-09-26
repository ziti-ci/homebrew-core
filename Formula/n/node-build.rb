class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.13.tar.gz"
  sha256 "24f080b2925508f4eb8bbf45ffab34eef70e71f2135aaf6acc7dec1217a9c273"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15f7ab2d62f1bfc868eddde22f94b9b958a535dfd82ffbfc8464f7d53e0ab06c"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end
