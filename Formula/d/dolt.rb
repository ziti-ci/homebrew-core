class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.58.2.tar.gz"
  sha256 "a88dae813d41e7834198959eb53d5fd2681dfad48b6b3bf4968d7fe53585fb5d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6d21bcc96a5efe09c2cbfef748a5995d90d38aba900a34ff20fd5980e47642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c36d818386a20f00bc6e33adf2f1cf1bebf5c2c61457f7f30bbb74b287133c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0eedba977f9291be564b5f2c1e04305f26f6f9a6dcda4db368d9816dc36eb90"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec490837800eee8bb460cfe6f9aa6262aff92f0197d2a356c531e3b2f1ac1886"
    sha256 cellar: :any_skip_relocation, ventura:       "b1d335c24e115c78335da42d7d4d09e94347e271f9ae10a0d638c50525c849f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c39fb4d98a30448e9a2128f5dae98666c1998f451519e5a87b957906ec77240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbb65adf7e2d4d3e99c6fccc7e511276739e71287cf73459bbb8cc7dbcbd622"
  end

  depends_on "go" => :build

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
