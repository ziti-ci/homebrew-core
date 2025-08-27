class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8fafaed9ffcdd2af3326831d914d032388f9ee0df6b195efe93a4a8d6ae8940d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on macos: :sonoma

  # Upstream does not provide prebuilt Ruby binaries for x86_64 macOS
  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")

    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list 2>&1")

    system bin/"rv", "ruby", "install", "3.4.5"
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
