class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.30.0.tgz"
  sha256 "9ee6a03769be57f6d3019138a7f588f2f39ad6dbe4204556a3b051bfd4a0e369"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c7b045bc7accf7b94114ecf59f4c7c3b30610a96562d5d908ef3d8da25fa138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9655d15ec1f74f114bba3d90e738b28dd078bfee13074f5e184bb54cd9a6c917"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d7938e55a112b922bb408aab25e92d5f379bf768f832cffa8119706e44608f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "73597cf095758c930f1ca58cb46c0a01a1a2187e3777df6547df5997d2c10a22"
    sha256 cellar: :any_skip_relocation, ventura:       "dd540facb3103405768fa167a47e9ba5742e842eeccf38aaa367eb939884397d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f462e499df1c63a7eab390e4d079dfe4b8c84f0f4441cdaea264059a9dbeb6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1812a6107ce7ebe9747955182b07451ecba3dd12b6ca410fea21ec70a08374"
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
