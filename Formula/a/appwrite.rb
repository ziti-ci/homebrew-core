class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-9.0.1.tgz"
  sha256 "9d3a6ac2fdcf563c23fb5bcf503eaf7873f3979bcae623ddbe7a9b7d5c7bae89"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c368bc8e90ac50c165fd5ea67916fb710f7fddc1bb457ec7b8dccbe0dd0904e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Ensure uniform bottles
    file = libexec/"lib/node_modules/appwrite-cli/lib/commands/update.js"
    homebrew_check_str = "scriptPath.includes('/opt/homebrew/') || scriptPath.includes('/usr/local/Cellar/')"
    inreplace file do |s|
      s.gsub! "scriptPath.includes('/usr/local/lib/node_modules/')", "scriptPath.includes('/lib/node_modules/')"
      s.gsub! "scriptPath.includes('/opt/homebrew/lib/node_modules/') ||", ""
      s.gsub! homebrew_check_str, "true"
    end
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
