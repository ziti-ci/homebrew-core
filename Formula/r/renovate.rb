class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.77.0.tgz"
  sha256 "2af2e5d97b560bbb3ec5c8a7caf4590763ce4c9f58c8ebd0216ffefdb25a4ff0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24bcf40806f0c17459863cf9d6e2571321cc2c40b5a5cc5e4607a960459060d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076a0eba41e3ce7bddf2de3d3fdd6e67181d005ecf2c1f6e0db4207ec7a441f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918a69fb030353cf7fcf553a49bd1e2d65271f3cc2db5de52ed7c59e580ac6cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "560cf0fccbe61fc933b01f5eb65b2b8426d729a3ed61c9e1e5ca540b8aa3ba9d"
    sha256 cellar: :any_skip_relocation, ventura:       "9e0997d772f4c24a302e393036aceb32771aea77f3aa9f4896c18ad21bf607f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd013c824b27be3697e000e76908329223631ee24fc7500dd166461f70a37602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "308893750b65abefa7de79bef51be88918bec75e914cbd268b7905acf3005ef3"
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
