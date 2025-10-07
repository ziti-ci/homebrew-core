class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "ab372bb555b5a39fb2763c2409ebf272cfa28e241f35ca960d3d50c678850199"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c26e1674e82c2e8fde58740cb4cab80783bab0b6f1690657294ed08c9b78fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e4f92eca8ed640305a89ce38d3747c26f52ac4c18f6188549d0f541d07f9ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e39261a84b479e1f38063593e5159341b1b431e7e757ab95599c99c2dd88bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f998a753117b9454fb1bacadc6550caaaa5ebbf5d476375000de557355e7016a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5b701d8a0959fa95e7dafa6bc93ae08bea977f63f9d32a0f722039a9bceeef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da98ba27b389e6d97c30a9b9e01bc0e4ea2020766cc2001df66b7a9e55335d4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
