class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.28.1.tgz"
  sha256 "42d1402883ef23e664a2c346d6bfc8352fc6998d9b2d07c1c1e9899228a76def"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2cab905dbbd7a0913a8b8f99c1d5163e79a1f76b63b88a4e56b8e9f4f3ad5ee0"
    sha256 cellar: :any,                 arm64_sonoma:  "2cab905dbbd7a0913a8b8f99c1d5163e79a1f76b63b88a4e56b8e9f4f3ad5ee0"
    sha256 cellar: :any,                 arm64_ventura: "2cab905dbbd7a0913a8b8f99c1d5163e79a1f76b63b88a4e56b8e9f4f3ad5ee0"
    sha256                               sonoma:        "bc41cddc9380d3be25cb9b3ba89aa82c0e9e9d9a74cc8a7e39abef1b1479f84d"
    sha256                               ventura:       "bc41cddc9380d3be25cb9b3ba89aa82c0e9e9d9a74cc8a7e39abef1b1479f84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1815c1c1571991d26a7fbd4d785f2717d4eb2472e7be8b48c9d5ba7f08c04355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650d46d04501b3a8be919da8d0b414a1ac0304910248ce274543a9d68f21118a"
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
