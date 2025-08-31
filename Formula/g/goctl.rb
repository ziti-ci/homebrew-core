class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.9.0.tar.gz"
  sha256 "e02c2ce3e101e2d0160498c87225d179ec2aa2eaf9967475e5abc3625a324899"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564901215889c1f79ef3712dbad56a0fdede3c35a5fcb5acb8a3bca4107229ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7962eb703b8f487542b15b51d3de6b3183d68bb710d55b0ee64369930ccf4a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "367ad2f1c5fb1e9aa5ef8cf6dd1ed1780a6588a488beb6e9064ce54fa02a50b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc09452891c4f0c5795a8bede3e452fffb7022c465d5ed824c5a6d56512c558"
    sha256 cellar: :any_skip_relocation, ventura:       "8b95bb69ce1c31cc83243bc2e7ed45715a2355570381bc8b63a7ff06b3e75ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ec3bcf70ee9021867597df1e27b16a4427196f61432a0fa4675a85ebccf5ec"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
