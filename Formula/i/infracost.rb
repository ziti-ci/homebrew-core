class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.42.tar.gz"
  sha256 "f69e980c603e61a2012c40d5b98d02debd0e032f8672110c184368bbe03b2ea6"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06de717bd785bcd624c997a14590ff47a188e31536d2fd5117b4d316c0dc6904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06de717bd785bcd624c997a14590ff47a188e31536d2fd5117b4d316c0dc6904"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06de717bd785bcd624c997a14590ff47a188e31536d2fd5117b4d316c0dc6904"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc82112097b2a1b05b8f578896e64a96374658385768a791330c74f42f125a7"
    sha256 cellar: :any_skip_relocation, ventura:       "bdc82112097b2a1b05b8f578896e64a96374658385768a791330c74f42f125a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a7f0284e9b3122b93b89771f00b0c5cea7ecef05d75e7231718242f5e548bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d521fdfce102614f8bd7d7e9e2adcd59ff807f46bfe24fe767e44de5415f03e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
