class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/refs/tags/v0.5.100.tar.gz"
  sha256 "371fc84e35e40c7c25339cb67599a0a768bc7d3d4daafb05e02ab960bde64ce4"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ffb42742131fa52e3c5f707930c00e6af3fd6e069b4f2c5f492881d0bddb4945"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
