class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "71796c060705411e98fc7d11d944c531cea1d09df14cc1331c5647a31483de41"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4dfbeb2489ea629158503fb8bf8c7e20f2070e3fd52b79b758e71dbf7cc9b51"
    sha256 cellar: :any_skip_relocation, ventura:       "a4dfbeb2489ea629158503fb8bf8c7e20f2070e3fd52b79b758e71dbf7cc9b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7deae5ce7021fe08b64a620299da764d98f764ed3463771d965527ff0bfe45b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
