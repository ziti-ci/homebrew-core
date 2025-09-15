class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-8.0.0.tgz"
  sha256 "7a750d4ff5577e09aa81a8379b2ec86e785eb03772cd98ce499f1b233b6e3190"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a36d04e340d1ba6b1beebe0b7ab42440c8d74b79bcd9d36f7ed0177436df0462"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_path_exists testpath/"blog/_config.yml"
  end
end
