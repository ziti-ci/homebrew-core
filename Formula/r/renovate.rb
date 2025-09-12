class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.109.0.tgz"
  sha256 "79555210f0a3a7d4f1c0c2ff5cc59c1273d07712e9167991d6eff0ce113f2bb7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386185185e542741cde3ae317dfbb16ddc790e19f4502db63dbb1d8aad091bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21a732d403efcfa49647ef261355212fc6c31a24731d5a532a305f787174c94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff47ba9dd766b8783a40d4ca98b1cb64a053de6dc6e608bbd6ec0e26eb5f38f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beaa350a8b962267a2629e0f6009c8a38d2e72e941509812ad93c7b1e942351f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e147efd88ce47740b073c3341b13d13a58370c93cb36fba8d1beb0233f22a75"
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
