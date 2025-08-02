class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "d5533dce84a02e4f731c95215b003d7e11b87c2fa9c54ccf40df65c5bd983f37"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f74593a948bb5c1d5f28d5a9a4bb78984f292a6a63892a64d915d5a2223d3118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4140c57f4f5f67d3f0706b0856477e6b9bc7e19863684e048b30086d9d75a4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39e2b41148062e5cd90b1840ec0ce5af974e898442bf9faafb342f3adb23d42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c210e071de39327ab40cc03f3c61b497a132db8ffc0c51e512fa0f76591f7721"
    sha256 cellar: :any_skip_relocation, ventura:       "4a2b25f767473e687adb172d1bbfc40d8e2251191eff5c14f1de35f92f998d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2193674d2eda73cde48f63f0031538883d64d113a3aef9eaee3e336c3c2c6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc012eeb34bf04a9e151b08a101c507bc1a1fac517b86bbf69cae1557a3d7ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
