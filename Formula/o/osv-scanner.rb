class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "129f534cb55c0811dcf80efec9da7314a4fd87255c093718db9502a4ba19f704"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7700bde0533f8519dbf8d8e33f09762af242201abd98e7d3d72da5ac5291913"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d213019a515a4fdee7972c076a6648fb747ddefb1b2a7f2399c058e20ff361e"
    sha256 cellar: :any_skip_relocation, ventura:       "9d213019a515a4fdee7972c076a6648fb747ddefb1b2a7f2399c058e20ff361e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52010343340ba0f19fbf552bf6e2044748cfcc71c78653067a76429ddc2ad526"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
