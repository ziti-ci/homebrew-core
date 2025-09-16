class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.13.0/flyway-commandline-11.13.0.tar.gz"
  sha256 "c88a6d9cd22defaa987abf4084b459d2186e521c79e8f5975378e390b073d753"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8e40329c5fb2df15e9622458cc33bc150ebf8731862ed6f8361bb0a3708ca20"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
