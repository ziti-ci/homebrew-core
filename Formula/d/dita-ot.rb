class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.3.4/dita-ot-4.3.4.zip"
  sha256 "011c65bbe55b917f572e8d8e81a5518504cff0706b436f1c8a6565a1d2d98f08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd925d8847c43b8a687966b5690a4f7a671526282c630424a5113103ec85e5a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd925d8847c43b8a687966b5690a4f7a671526282c630424a5113103ec85e5a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd925d8847c43b8a687966b5690a4f7a671526282c630424a5113103ec85e5a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1bdece1b81a2bd1d9c82d605c7921fa107065e1dc99c77ff36eccc2117ffea7"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bdece1b81a2bd1d9c82d605c7921fa107065e1dc99c77ff36eccc2117ffea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55711435f2720e496c03305d15362aa38df8384c3cd178d0a9907a6fd2a60ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55711435f2720e496c03305d15362aa38df8384c3cd178d0a9907a6fd2a60ddc"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat", "config/env.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_path_exists testpath/"out/index.html"
  end
end
