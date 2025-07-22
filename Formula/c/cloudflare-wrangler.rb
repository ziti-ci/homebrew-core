class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.25.1.tgz"
  sha256 "f7b05507ac56ace567b501d8f4a5f9251070fc348c43bc66349d5fa2cda03015"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1475afbcd14cce5452c1929b4c51365627c59e099281c6c93178d37f8803134"
    sha256 cellar: :any,                 arm64_sonoma:  "d1475afbcd14cce5452c1929b4c51365627c59e099281c6c93178d37f8803134"
    sha256 cellar: :any,                 arm64_ventura: "d1475afbcd14cce5452c1929b4c51365627c59e099281c6c93178d37f8803134"
    sha256                               sonoma:        "bc6a4b7c48fdcd57a35836e811e3cf6ddc81a08b8ab6047a2ce0beed59b21aec"
    sha256                               ventura:       "bc6a4b7c48fdcd57a35836e811e3cf6ddc81a08b8ab6047a2ce0beed59b21aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a272f3c0c2a8162cfced9d5a96f0bf0880d121ce704800b3bb081a1fadc73164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604d3187a4155b0f07c8f6ec2c20040b4d16e1cccea231e673a2649d0b706b03"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
