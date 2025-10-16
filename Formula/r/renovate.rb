class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.150.0.tgz"
  sha256 "426ddebcaea45b56a90902c551ff1c249d3ee7585df2cde8a443bfcecfce04f8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0283763f90af205156374a121efa23eb6f8868b6b570a74d85da9d835d05c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d882395e01cecfdb9f8cae4c1540e06e5a675477570f783566ca7f31850921b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6bcdd3c96824c051b1328de8cf288a9bb2fdedafd526bb4e42bad369ed2ea64"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd59221e9d1b67653323e6b7972d08e0402b02cf061f8d5954f1a2083509f45d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130b4c11d65d75e22aae506e3abbb1f4649cbb6145c09ed8637c0de22ab05143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c134d07473a1759475c89a74af006dc91dbd88cea065a64def34d372d25a8d4b"
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
