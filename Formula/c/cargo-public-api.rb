class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "779ba388aece1227bd074c39bf90eadff7e9edc1238d6d5691fd69b4bf8cd47c"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b38fc8ef63a5fe15741ef497023fcc55cf89b02f315ef11f05f3b22d84b7d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ec83ecae8f9127fe6890a9bb89bde5bfcf0cfdeaa1b9d718858f940c7543e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a34c80a4237fce67864f291d91a9e486db07a65053880ea5da1b0cae9f4e93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4093bf1afec2155a928432f489d8aa64b7cc7b62cf7297aa80fc84b63fa40dbd"
    sha256 cellar: :any_skip_relocation, ventura:       "c59cda720ff6e03d3f712138d824c90becd4d5a3edcde8bbce80e09b9a4480ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92cbdcdb7dcf1a24004a5be67539a1a5773a9fbeda469a88958ea09acf27785c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f112713874725343d453fe6bfb25f966c7f602023fd5ded0f6f2948ae857b896"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin/"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}/cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}/cargo-public-api --version")
  end
end
