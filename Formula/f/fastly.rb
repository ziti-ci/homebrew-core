class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "f00a924e51afcb177aac08b324f5d0e6b3fd96a409c8b62d38e2dc9e62c76294"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a0d6ad98090d9496d07554217341b13053cf88204644fcd2fb6ecb50d822ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a0d6ad98090d9496d07554217341b13053cf88204644fcd2fb6ecb50d822ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a0d6ad98090d9496d07554217341b13053cf88204644fcd2fb6ecb50d822ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a0d6ad98090d9496d07554217341b13053cf88204644fcd2fb6ecb50d822ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "427027c3725a467cd1bcf47b246904de589d7c8ff5ce82497887a14e995111f4"
    sha256 cellar: :any_skip_relocation, ventura:       "427027c3725a467cd1bcf47b246904de589d7c8ff5ce82497887a14e995111f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517210b0441d738332357d4e60313dd22e2c125af91c0223055af875bd998c78"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
