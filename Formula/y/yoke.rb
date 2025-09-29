class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.9",
      revision: "e38648b600506df4901c9d4193f3eb6170a8a225"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d50fc5ae5727584a2d86a84866eeae9fee75aa9ceb8d06d0cd170cc941bea47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa3ebbbca08ad74da0170a8981784ce902c0c740f45d34d617f5a5b79951a310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83954c6b553ab8d3baa7514c0b48d0ae7d66cc608486f0dcddd6ad996612fc34"
    sha256 cellar: :any_skip_relocation, sonoma:        "38184681f70b86c7c5c1d6958885bb950a033b7e40a19c2c6de9affdae22271a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62324e04b04cfffa6947fcc92b513e3cd5e1092a9be1369a3200ae7686372a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c1d4c708c78e32b16e742f672eeda82c8dcc3216f4559c5d10dccc1f3bb0af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
