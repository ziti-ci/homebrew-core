class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.9.2/easyengine.phar"
  sha256 "9ab928c4e5795a456386b4f30faa0d1c1ce4c4d4dfbbb245e9b4ac40d35b0ab8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, ventura:       "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    return if OS.linux? # requires `sudo`

    system bin/"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match OS.kernel_name, output
  end
end
