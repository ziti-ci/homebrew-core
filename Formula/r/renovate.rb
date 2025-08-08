class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.59.0.tgz"
  sha256 "a3bbbda859f03e8f9ac44870466d1624ccf72ca1183181e26f99f5925562a935"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf78798eaa850ab7a34bc35565bbc9f8f01d21f549b3608bf4fa30b591ea7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "949c18a00f8947b817da1de850167615413be68f19aef1d916c38eeab6b425c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e217410cf1b0b20b8f26c18d663859e1537094a6350657277af62628ca40e1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d49f928cce61551c3d986788f30418e20b76f4deeff4478cff69eb7510f352"
    sha256 cellar: :any_skip_relocation, ventura:       "e0bbf6bd7ef4670f2d461bf30690569f4bfc3a2ca53c117edbcc2c5d0c192a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fff0fb82b3e3535c5d8b4efb0ff93f24f01d604ca80af079cafd57f20e357457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952d2dcb82f33eba01a6bda9365a1c742de76714210bb8ee72015e679685c19c"
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
