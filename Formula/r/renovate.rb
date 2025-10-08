class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.141.0.tgz"
  sha256 "55d42c09629a48549f217548c9dd338ffc6e1bfc033aa942f5c70a8f13b8089c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cba1d1a5e7e10bc5ba983f60fbe4546fdaf67f074ccc78973ce0e49c3828aaa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8971ddfdb6c2ec9f29d6def3e47e81001768a640f80ce3e15064c1effac3a813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446c326d61434701eab9cac41c6f7548dec89dd96a4de1e3529e1dd196c0bc9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3717a9a6c95b26412d2df89d1065a8bc1c567b6e13263fc5a55d608e6c9dbd5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6278aaa21ab86c787de4d10270c36ee33cfa7f4ddab91baf91d553c1db4b47ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365219daaf7d2d7cea9168ae95fdb3f253460cd7a8187d50721b5483dd91b00e"
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
