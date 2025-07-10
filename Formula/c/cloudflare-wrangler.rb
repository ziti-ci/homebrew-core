class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.24.1.tgz"
  sha256 "ae693e686ef24ee2af3edca84f833ff7d8da6af5851cdfa68f444f9426f54ee8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d8113e27c601d0ae9f0c8fa830a45fcde67edfd781a8c3d02b58f4ad7a5b970"
    sha256 cellar: :any,                 arm64_sonoma:  "2d8113e27c601d0ae9f0c8fa830a45fcde67edfd781a8c3d02b58f4ad7a5b970"
    sha256 cellar: :any,                 arm64_ventura: "2d8113e27c601d0ae9f0c8fa830a45fcde67edfd781a8c3d02b58f4ad7a5b970"
    sha256                               sonoma:        "d1c575639938fc4761f225ef58ea48654c542a623a5d98ebb8473ac304a42c0b"
    sha256                               ventura:       "d1c575639938fc4761f225ef58ea48654c542a623a5d98ebb8473ac304a42c0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0ae0999014fb80c2d7cb84dcd5b9de8406d124c861905a1e32a2cdd057f97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e49a634fd6df32c2fa7ef6495144e3629e8d2b5511c8217ca3ade8d382e22c3c"
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
