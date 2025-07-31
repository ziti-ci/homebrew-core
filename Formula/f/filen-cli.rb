class FilenCli < Formula
  desc "Interface with Filen, an end-to-end encrypted cloud storage service"
  homepage "https://github.com/FilenCloudDienste/filen-cli"
  url "https://registry.npmjs.org/@filen/cli/-/cli-0.0.33.tgz"
  sha256 "04d97ed98394402386fefb8847055bfb3915fa298b3f47001d705946cd6a46f9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256                               arm64_sequoia: "c98c84160e42c188c5ffba257bb667caeb38eeb0bf7bc1f0e85b0cd60bcb9adf"
    sha256                               arm64_sonoma:  "c8f038324111534f7e3ad7bfedbab5e13e1d21c55b22fb8fefd1d99fb13e5a8d"
    sha256                               arm64_ventura: "3fc5d84274a8f6e37fdfa8397d1ed953d52cb590bcb4cc64d9ea0fdf2d9d66fd"
    sha256                               sonoma:        "bb9db1b0866e787a63dc146ac8bbbb99383640ec140d909b44f34fb80b866946"
    sha256                               ventura:       "e193906a4e233c32a72583476b7ce47d63d084c71b0672cd2ef9973bbd9d3624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "999b7f5c4d00acdc8b0eec7ac089ec23177cdfe73d3c361320ef0897ab60db42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b7688976ec264cc9ec27879a8d0a4826fa9f02f214aa655ef3261835f84193"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/filen"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filen --version")
    assert_match "Invalid credentials!", shell_output("#{bin}/filen --email lol --password lol 2>&1", 1)
  end
end
