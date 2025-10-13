class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.0.tar.gz"
  sha256 "37484452798c719696fd7af607d529479d07a049a678423fb15a8c45f30bf240"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445c9869e4b50d947b2de2ea85a3231dc8a0d64c10ca8ff136bf54872a66dce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08a00c00f39cf02260ab9fda739a894c97eee169ab40bbad863b80a0fff4a0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08a00c00f39cf02260ab9fda739a894c97eee169ab40bbad863b80a0fff4a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f08a00c00f39cf02260ab9fda739a894c97eee169ab40bbad863b80a0fff4a0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69d9a156e873b11d5b739c59f295c022d2bc212d7ac25997a38bf3800038ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "e69d9a156e873b11d5b739c59f295c022d2bc212d7ac25997a38bf3800038ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8625f16b2e12a691f36783a8e2ce77f78d34bfbe2de6c371fc9fb2569d55d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaca5db149b0e768f7bb37129a66e8197c59b7f7fbcf7852a832db07cc09c2ad"
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
