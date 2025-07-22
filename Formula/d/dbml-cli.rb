class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.8.tgz"
  sha256 "f8f72442dd73284db5eb140379cdec5485974085a409ff64de84c7f5d8d02a1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3234a1a5061aed9fde23e36929a4b00c82b844118e89b78b6cd8bbdcb63c8e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3234a1a5061aed9fde23e36929a4b00c82b844118e89b78b6cd8bbdcb63c8e74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3234a1a5061aed9fde23e36929a4b00c82b844118e89b78b6cd8bbdcb63c8e74"
    sha256 cellar: :any_skip_relocation, sonoma:        "1061eb64cea1bce72f2a0650e32c504b7485e13d1995c83c1719f1e954c5f3ce"
    sha256 cellar: :any_skip_relocation, ventura:       "1061eb64cea1bce72f2a0650e32c504b7485e13d1995c83c1719f1e954c5f3ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3234a1a5061aed9fde23e36929a4b00c82b844118e89b78b6cd8bbdcb63c8e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3234a1a5061aed9fde23e36929a4b00c82b844118e89b78b6cd8bbdcb63c8e74"
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
