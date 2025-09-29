class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.131.10.tgz"
  sha256 "970515b8051b9a5412ceeb1bcae6b0042208bd5b8b60b7812eb8260ab3b4e59d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cd2ce29bcb667968dbe91ec3adb0328504238e5b091b6f9c1c71e45b44e47f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3b01a3584bd1207719ff2f1d5a6a8cc51d2876b4543dcfc3bf593ba7c13f06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76748df071dc784eb2cc33979cafdda55baba921f7aa242a6db1de3b9db18a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "646b8c9f1f4bca73bde1cbcee1251e48fab1068b3c93ef3c51ab5f449f091bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c4f5bae140f5f68a7562c0797ab9781e5e26a5b666e7f7cac13e2aacccc7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ee5ddf64ea99025d25f62d57c357634afbbf869cb7eecd10f02ada43b1d387"
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
