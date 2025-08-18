class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.80.0.tgz"
  sha256 "2d8132c6779dd65de650905816d026b3d07fe386ef1211f694fe578a85d5a969"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54b90e7561181df981458609d27885af7d893dfb10e0562b6e45152fde606a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a057b82399e458665ab61c9d3ab407201478d3d15ac2f68fb4c0e3e7c3cec84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "586ebd4d6734cfdcdc5d1b82ad5edbaf00b66f40c83d1d0258c379b8be43ba86"
    sha256 cellar: :any_skip_relocation, sonoma:        "3561406463a8371cbee63b8fe4e25db9b36bdd3f296a77b57f75b7e9504a3add"
    sha256 cellar: :any_skip_relocation, ventura:       "96e4382f9fd85718259dd8fe5fa33aa8f3ab96fc5bd9197dc616edeefa707bde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498a6e662859e72d5b65aad44be805bb0c5f0f3c8d5e5df228e5dbe1ffdbc0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7a74d2d300005d7756f0faa927c8ea3790f5d91d0f54fe5f40f885b9226d6a"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
