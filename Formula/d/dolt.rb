class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.11.tar.gz"
  sha256 "3ef83395597d26cb4816bfd5943e65a9d4e924663de5bb4f502d2842bbbb1811"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9fd7c8b95ed33cae1d982f90067ff295ce56ec7dee1309bef505aedb09ed260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fe56652234976545a96597893a7984fda825724c9780feb0bad8e6dc3bbdd44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62cf5b515cdf4b442d5416ac2bb39e61d94a0068420e132bbc42e689421ca3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e1f7235de60380e278e82088b3af9b6dbeb45ff8b00ef82623281ec7a489dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d877d00a1244e020cbc2e77fb591a47bf5fe4ac8b1457881962459fc7d74eaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f22f1afa891ab150177b61e217fe520ce252861ce5bc60247c608e04707143b"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
