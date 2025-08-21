class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.103.2.tar.gz"
  sha256 "77d0201a5fd09df066a04a2bc1fa0acbc01317ed62ec04a99b8cb8a0ce2ce3b3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ce56fe1c1342bae8b6d41e6714124529cb2a89e3a1389716751ed0337e1b695"
    sha256 cellar: :any,                 arm64_sonoma:  "bb0e5e1e6d817f74c476407daf7303fe96769d9568ee52883f1fb7021147cb0a"
    sha256 cellar: :any,                 arm64_ventura: "2bbb95b323a5177f540937b8cef4666fba91035edf2be798587e385afc7c9798"
    sha256 cellar: :any,                 sonoma:        "48b695b64a6738f51b9289b16e65b528a6c06c1e9280b25dfe94ac0e5892dd4e"
    sha256 cellar: :any,                 ventura:       "17ad82f2b49ba17e7373d8abb670c74da174d7b48fa28554219dabd68d7b4f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06541efe85fadf05a8c6f579dce61d4183155ff5c0c2ca41493dcfadcfb567e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907ec41da39214573e617d3d283f22b7dd073dd2893e7d23c413b77b7298b0b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
