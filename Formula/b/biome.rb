class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.1.1.tar.gz"
  sha256 "678f538b8b5696f94e0bb8ba2a63c2e5c785a01521b4b5ddf70307769a6c78c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11525f662f61935101eae147763ce027e0da6549c062626473326a5203d64186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b85b7a67bf2b34c06dee8caa7c052464ee1dd0299a0f521541160f448e526cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de07ebd3e668c6b814ad788cbb7815cbf78c3b1a4a0f9b3cdb262e5f01434a47"
    sha256 cellar: :any_skip_relocation, sonoma:        "214a4763408b3d5d7bf5d8824813834d7837d568cad548b25fec36c123fcaec5"
    sha256 cellar: :any_skip_relocation, ventura:       "6acaefe6d0eba4a89a121ad6b216722e3aab657a2f094ebfb7e4a5921d05315f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37b00c1d5add7c17a6e74c85c27fce5b9159fa1c94b8bd165983c865d8541f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "901262c7c1522a8932d6b9d1710bcb0a3f36f5bb23b8d9c8bc2b8ed94d0e31ce"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
