class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "e1c17c94cd57771cc6df35c583d7be7131e8efcb938c0ed46ae342518510d610"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ed8141e7d5e1717a523b1c981a4508c2314d43e927f10e4543742bc014ede1d"
    sha256 cellar: :any,                 arm64_sonoma:  "4134239d6b9307982ca7107ea08a02d6f74e50f966a7adbeedf432a8faffad5e"
    sha256 cellar: :any,                 arm64_ventura: "75587d6ea0bf657c326dfbef53e9c10c9c3e65523b00479c63cd85aa97335699"
    sha256 cellar: :any,                 sonoma:        "c1f3ab2d7810d43d67bcaa2290f269a14be8f02864dbc9e95b058b5e94a4dd61"
    sha256 cellar: :any,                 ventura:       "81bab254a49a38c82078ddddbcce585c77620054bd907384f7d9638d87925bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9974fe312870c195fbcc3c918c8c877714b4f0ace0abb12496a007019bbfee3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d37e76bafe0dbe5d1b008062534c2f2e5378caebd454d45c6308678b439637d"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "libpq"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https://github.com/citusdata/pg_cron/issues/269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      # We force linkage to `libpq` to allow building for multiple `postgresql@X` formulae.
      # The major soversion is hardcoded to at least make sure compatibility version hasn't changed.
      # If it does change, then need to confirm if API/ABI change impacts running on older PostgreSQL.
      system "make", "install", "libpq=#{Formula["libpq"].opt_lib/shared_library("libpq", 5)}",
                                "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_cron'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
