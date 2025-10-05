class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "66d16fe3ba99790ff8a1e4e5f7c2a4f2b84055750b5caccff6cb9d6bec1d72f4"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc05db581312d689182a990d8c0ac757614dedc7dcbd93f8dcb3b18a7386b4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7f3dbe8257479201bec2f7ff0b2e9b5d5334d768cb8c1204d769822e212513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc53f2ba0a7208e459e65300d05b71d629abb93e460f81782e4d192a93c31bca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e50f867a382bdcce2faed20e0d00267c1dce793a7fb289c660b0cc9125d97972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5ca7a80a50fd790c096663ba363d274eda5a00eacdc65b00156fe9689e17e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b11292ea7d698d3dc06cac7d1ca4d9c205fd0bd26f1280e3df8d086a7d5e1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
