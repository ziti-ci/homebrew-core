class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.15.0.tar.gz"
  sha256 "d42b02c11577aca112efa7e5ef3cb011e5355e9b3ea2bc753eb6a1a1cf1177b4"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fda1495e6af67b21c960c2e689e47f77219c6106fe129b01c3a9b58e48b4811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fda1495e6af67b21c960c2e689e47f77219c6106fe129b01c3a9b58e48b4811"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fda1495e6af67b21c960c2e689e47f77219c6106fe129b01c3a9b58e48b4811"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ab4366ef34f75854784bb508508836a01fc3e39588e41113dedbce72f7ee69e"
    sha256 cellar: :any_skip_relocation, ventura:       "6ab4366ef34f75854784bb508508836a01fc3e39588e41113dedbce72f7ee69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a576590ce72f482fb6dddaddb5a0c823a9c57baeed9c67e96f0d421dcfbe1862"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
