class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.3.tar.gz"
  sha256 "ae8f088dd25a10406e8f7a27d9ddc555d28d746950fd653f4cfe42ab0b903f58"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b7c05de35a1d57833aff7309fbe7f05d98ad80686ab6233906a5c5e458c9f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca18e30ed084337c77376f0af8b97d3f10bc3ccb20660f7d74c15644fbcae1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b45f360b6662b147c5adc50425ef87afac800c9aa2bdeab1f2f395614ab34b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63025c662d67807c0f75b4df08c26b5af01c2e602d5438e2a08289b7ce8bb350"
    sha256 cellar: :any_skip_relocation, sonoma:        "468b27e2ac00706f31f56fb7ca8fe5aebd31ffa282aae0b21eb8ec487a77561b"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c75c28e02b4c7cede59bcb1137c62cfd34801b9a06d11855f96f0080829756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b7c26038caa3a4a85bd6eecda38bd3742864f92eaa01fb225802c28b317eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bfaef19e583a5409511f21a9853c0c37d5ea0067782cce94a92ea791200c4b"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", *std_zig_args

    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end
