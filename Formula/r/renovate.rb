class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.39.0.tgz"
  sha256 "bf5e6ee5cb50751d047fa04bad60a242df88e72657bcd267f9c3aacf1ad0af80"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65cbec9480aef0ef309bafc73bebb74951fe8aedf22ba10a65baf4d392a8ed47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2910c6f0c5e551b878f0bf3e1718c7a5f276eb171d3faa3d9f1c176fc87f181c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a359615286d1d985d5a9cbaa024b40fd72134568388e2a2657783f76bcb3fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cebed55a4134c47f1a9418c79e0d762611dca22410a3455deb3e717135ddced0"
    sha256 cellar: :any_skip_relocation, ventura:       "26525c0ab8b3e001e912ce75bb920efb2834b42af278bfd49a83b9bbd51beb14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de4e2ff810c3e19cfcb9faf007174cea8e859720acf048b3abf66179b02d44eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a083a2ee782b2db89df2256746279d8d87998c155aa577c5b4d2ba9aea457512"
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
