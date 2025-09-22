class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.303",
      revision: "73cb889700bbf1c6637a6fdf0266c287f527162e"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64656be8f66b957d98cfe2689d89d02a85d734a786912796106b82cd7968d481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64656be8f66b957d98cfe2689d89d02a85d734a786912796106b82cd7968d481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64656be8f66b957d98cfe2689d89d02a85d734a786912796106b82cd7968d481"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e50b5f7b9e0ddb6fe6274bfb1ba96750f9fdedf9b9ddb92a52417d4e85efb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae690c91d8ed38bd99abae0c35d1b446f4e2853da112aa8bff4181b1fc11db89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
