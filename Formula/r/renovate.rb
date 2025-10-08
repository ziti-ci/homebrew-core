class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.143.0.tgz"
  sha256 "66c2519dffd7e188b1f32eeb80726481ab30ce7f7604441c027e55e67007d7c7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b94f837d16e456c9dcefdc18be06ba08a156d80e4f6572d732d30339a34208a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "defa1bfce63a73f733947b2130e7abf17a5adb549664a20dae6bed59cd6e3328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "485409bb56d7067d0cc838c796e56796f8f414bef77dd1d2d782f84e7b7448e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "089a056905528aca4f7a41710d4cf85fcb2d4d9e9005141ec305cfbc890f23e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac811456bfffb1e2365943fa9ae36fb24503c12107111806ab2a1ef21cf0d331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2eb6f76799da7d665282179a0d6395783cbc55564ea8877ad62cf015d2916e2"
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
