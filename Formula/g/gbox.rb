class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.3/gbox-v0.1.3.tar.gz"
  sha256 "cebbff5be20e0b7c669e0a2319a41fa8e01db1e84668a84f5ccef5185cf55f23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf81420f48d3e6b8ac03090ffd090ca42d5671ed1e9ffae132703e3b6775e1f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d3da1ec42eee1f11c7b50879bc6c8e4b655d12ea5097cc0cb076124d20d575a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e9a85cf55d594b1bbcaa4208f533bbc41829385624abaf68218b7e48d33e605"
    sha256 cellar: :any_skip_relocation, sonoma:        "42221e4ee30ac38f8b20e4039178893220d98317dba50394464847de14e428db"
    sha256 cellar: :any_skip_relocation, ventura:       "334e6efc62e7c1edb6e84173a24ba6fe1e8d2cb79f7ecfe7f1c430ee2a09dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c799062e1d9c613bc27c54a9cb124ee205247f3895984053c43d4d21ac3b6bb9"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "yq"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end
