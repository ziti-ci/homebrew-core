class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "8109df3c0ea5798a8a77c29cd8bc41a74217ececa147647c624fa45505f1ea24"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a9fb3d32d9b3005befae33e51fc76749d458e8ad80590c96cabd0d360bb4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a9fb3d32d9b3005befae33e51fc76749d458e8ad80590c96cabd0d360bb4b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77a9fb3d32d9b3005befae33e51fc76749d458e8ad80590c96cabd0d360bb4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c696147556ba2c0a077910777245cb9d2756dbd3ab0673d152f83740a9f8b864"
    sha256 cellar: :any_skip_relocation, ventura:       "c696147556ba2c0a077910777245cb9d2756dbd3ab0673d152f83740a9f8b864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3170bc3433caf14959d719a86f4a3115ab9a97bd80130ad76b0b683da56aa8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d53da90f5f41a6decb0b9a8eecddf9c5c868792eb68fcee81bf790899abcdfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
