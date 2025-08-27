class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.86.0.tgz"
  sha256 "4e174328762206d375e5fb876474d1674e811abc8f168188ba80fa06f83e2bcc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6d8b473c55c068c74b22011f396ee067450311fee5cb76b9811f16fcdefcdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b17df7a8df58bfb8006beb29fe0252100acba7a6f8b497d452451bbae0a4326"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dd08106c53c25e7ad3a7fe7da06e09366f037052baa38d4fe4a485051981599"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f4d02fdd786b1f5b37c90de59ef1dcac3fe7f27b27348f577403025dfe94c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "0c93a0dac9263ad7e985336c96f3a3eb9537f108c1fb4d5d2a94eac604033bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0abdf179be1be0ff3247aca93afe2ca1ccdc2ea63d6ac0f3f135fd2a5375bee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9387e00d9dff4ba88c83905de228dfe6d1f11e0c797a991542f2e0caf1c5a11b"
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
