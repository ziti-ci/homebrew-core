class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "6256153b5f79c8320860978456645442fd696ed8a8bb706418cc4e1627661023"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9080a919ec9c5aadcb4a826d5e186e1cf32e26cc021a8f80b67f890930dce8e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9080a919ec9c5aadcb4a826d5e186e1cf32e26cc021a8f80b67f890930dce8e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9080a919ec9c5aadcb4a826d5e186e1cf32e26cc021a8f80b67f890930dce8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "853f537fa86a3c78b48fb9c61a61f7a4f44d0ae1d881fba8a1f6de8fa60c135b"
    sha256 cellar: :any_skip_relocation, ventura:       "853f537fa86a3c78b48fb9c61a61f7a4f44d0ae1d881fba8a1f6de8fa60c135b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96f1e902da1a04804458bff51454e53425535580b3eaa18568b1a5cfedbef0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acaf23ff1d29b03b2b34832545e30b882d197557ce1b0ff0dd120b543dba0eb0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
