class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.579.17.tar.gz"
  sha256 "5fe7efee2ca94e3a068ba2cf237f7e45076844a00ba9a6b42409e1e0539c4a91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f977c950d2961860c511534ed06a1d44d7ce46d0eb13e216d330a60332082e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5312ae418ab803ba491bdcc91c925287705f8931767f7b9d8d1304070e81a198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc5f2aba794b4e6e02d1c76a5ca811dd6081781730cd3780352b9be43e1010ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce708e3e4fa8b8b310c76c2dd4514057aeb507d12e14897e7107245721e10e20"
    sha256 cellar: :any_skip_relocation, ventura:       "3636598974a36fb59de0e25876bccc974c4856026bb06ed90441ca3facae0c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c31536c834cd16e45e8bb52a344403eefc92d15638fe716692dc6473b3190cf"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
