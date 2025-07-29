class FilenCli < Formula
  desc "Interface with Filen, an end-to-end encrypted cloud storage service"
  homepage "https://github.com/FilenCloudDienste/filen-cli"
  url "https://registry.npmjs.org/@filen/cli/-/cli-0.0.33.tgz"
  sha256 "04d97ed98394402386fefb8847055bfb3915fa298b3f47001d705946cd6a46f9"
  license "AGPL-3.0-or-later"

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
