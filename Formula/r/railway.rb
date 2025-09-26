class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "e20c95b6a1db1271f885ba8e138df9592dac33f41a21dfe610e0a9c2deff4ad2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9135c3f7dc992f8f852edd912e96be8f0dfb8da9c60f4a85247f1232149fc2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2093da0a3ce5291fee43cee523938d10d18966c1c9c588783f4be3953273bdec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e86b14125e45e13b09fdd38be2feb1bf2872b8d8aca0d3535415c37da5e826"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bfc29acb90b47d59880d6f5ea5072321b5799ff85b28b8382f09bb502f38a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eabe070a64e475b41a6791e0339b975f401a2cf23e7aadbaecea02fafb3cf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32214113153228f4a76c346597b0a8009ecf1e3a9dfcbcfc60bb1732d175d596"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
