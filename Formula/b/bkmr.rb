class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "48ab7e312ec7adac65cf32b997a17eedd4a3d42e75c3f8b7d95bd2a6fa86a959"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ad31e0bceb043476b6116791166480a0a758cdb8b0504d1513b471511aea94a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3350b87d7a4cf7c53c668dfef7a57e2ffb7f0b3ce13a271ac30c839854e2f3b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bac518659b7b48c93f9601d3f1af47e738430bd34e5e8987bb1d3a84bedb9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e06fd24d1b7c2ee3b10c6adf6256ec43a3082b5f76279e2d9f68f3b7c7e5b0"
    sha256 cellar: :any_skip_relocation, ventura:       "d64792e30c7a33bf86fa23749935a580abdde521d4cabea312107c183aabc36e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fffc5691b11d95e6e019ffb650aa810e6ced5d0dd18c1056abbe14cd34507995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881f666cd8806872dc46e33ec2638a828b1a2d27bbe4ac103e5a7d6e52ac9f5d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "No database configured or the configured database does not exist."
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
