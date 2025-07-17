class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.9.tgz"
  sha256 "e0d461ea81b519d6ce43bbd4f4a15a5efcde22d793e607329957cef759f15b4c"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82059a38023217d06a5db158dbcf63c0bbce45567b8dcfa84e2e2e09ae62b094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82059a38023217d06a5db158dbcf63c0bbce45567b8dcfa84e2e2e09ae62b094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82059a38023217d06a5db158dbcf63c0bbce45567b8dcfa84e2e2e09ae62b094"
    sha256 cellar: :any_skip_relocation, sonoma:        "51547e82bc9f56325d6782fbfd088d75c0ae0172e6565e2c15073127eefb7c0d"
    sha256 cellar: :any_skip_relocation, ventura:       "51547e82bc9f56325d6782fbfd088d75c0ae0172e6565e2c15073127eefb7c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd8df1905b5fec2c5c53f95fa2d1a588604434a66a7e9d43d1ddf6bc429092d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd8df1905b5fec2c5c53f95fa2d1a588604434a66a7e9d43d1ddf6bc429092d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
