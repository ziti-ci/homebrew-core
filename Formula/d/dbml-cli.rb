class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.9.tgz"
  sha256 "f75f57714510cdb0b8ee5ba3e69a3c050f7cd1ecc12ce0af9a882ac86ebc15c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15304400e46598504df073029a22fa1d7239727b584db6bcde66f244e698450a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15304400e46598504df073029a22fa1d7239727b584db6bcde66f244e698450a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15304400e46598504df073029a22fa1d7239727b584db6bcde66f244e698450a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c55cdcf1162ffce46dbb5feb83adca3cd69f1cfbe2cadfdea4788a8818bda8"
    sha256 cellar: :any_skip_relocation, ventura:       "a0c55cdcf1162ffce46dbb5feb83adca3cd69f1cfbe2cadfdea4788a8818bda8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15304400e46598504df073029a22fa1d7239727b584db6bcde66f244e698450a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15304400e46598504df073029a22fa1d7239727b584db6bcde66f244e698450a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
