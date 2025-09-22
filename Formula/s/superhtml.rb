class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6b6938446b86478608df954755ba0d212e6d2defb4b12d64395c79a091d9c087"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b81fca9fda9d025d1f057be7780b5e5a0905597dfe1963a9e9abd151bd4dc82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fee37c33e1945e1b65754df3584ac9f9460e612c1465cb7a8c99a7fd4320545d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ab9a454ac7aaca7371a477f80d49f0fe0f7029747e4041332b13a3d00cf534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d23e940a93d67b167a7f581c1558eb2c8576c94c3d9e0acfa0772fde7f36a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eff6f7d3a54c0286b29a347c69d4aedf8d685eb28e48eb8dbf1c4aa82db437b"
    sha256 cellar: :any_skip_relocation, ventura:       "59b688fbedae2f2e86cad38aff7ced5f84757c8986151abb42c7bbfd86fe78b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e298e19fd4b396615ccfd7939ab11dba25d2668533b4e9a3324f0207b027ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffcd873d33cbb738fda0172a485473d7d2f5bf7c0b642b7c7ae93e840daa98f"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    # upstream issue: https://github.com/kristoff-it/superhtml/issues/108
    inreplace "build.zig", '"unknown"', "\"#{version}\"" # patch fallback version
    args = ["-Dcpu=#{cpu}"] if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superhtml version 2>&1")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML
    system bin/"superhtml", "fmt", "test.html"
  end
end
