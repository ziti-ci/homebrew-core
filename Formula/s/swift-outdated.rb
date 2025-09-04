class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.10.1.tar.gz"
  sha256 "d2496a02c6261a72025d27e526cdbde25decee5fe790593f90c1661af63430ff"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade4c7adfde0af5a2ee48844fe9e56a2123c9f405313f0788aa0b3badaf2869c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ad82c4488d00e1df818ba8775bc5d815e8ef8bab8eae341779576ba1930d19e"
    sha256 cellar: :any,                 arm64_ventura: "7d0ff0f79bebced7fb5cf22dc02fc383091702368b349cf5986a39ea0bcc79c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "369c5044c48ee171ef668574ea3aea4c679aba7a73346529b3c3151c7ea6d537"
    sha256 cellar: :any,                 ventura:       "d585e2dae12aeb2b3b4418244b75b61a71ba0e8986244b8be8b581c846b832b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d7e050cd6284e891fa19602fa216a4699acb1e70b377b4647e5bdb16759fe5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "044967836e5cbfba575014e435b7c4edd7597a91587b5916664c99a50a778964"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
