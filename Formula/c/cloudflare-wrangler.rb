class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.27.0.tgz"
  sha256 "62342e7fd6e894e91df0cdf7724094235899a30aa6d711dc1d097f063474b1af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f6aba10dc8e9b498703cc14348d318d020efb5b5111eba0710b761cd40282e9"
    sha256 cellar: :any,                 arm64_sonoma:  "3f6aba10dc8e9b498703cc14348d318d020efb5b5111eba0710b761cd40282e9"
    sha256 cellar: :any,                 arm64_ventura: "3f6aba10dc8e9b498703cc14348d318d020efb5b5111eba0710b761cd40282e9"
    sha256                               sonoma:        "386f8e0c9a32dda5f7b7d96ddde2e7a6c04d681998fc0a82d9189b0c59ef8baf"
    sha256                               ventura:       "386f8e0c9a32dda5f7b7d96ddde2e7a6c04d681998fc0a82d9189b0c59ef8baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa90a36aa471abf340953e3554eacd344cfbc41ba7a5b16c6710645c2a9a427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c25f806ce91b75d9d51f7529c42c631e50c6138af7a2d4cd1dc845341f197c5"
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
