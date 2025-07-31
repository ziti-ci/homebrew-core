class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.10.5/flyway-commandline-11.10.5.tar.gz"
  sha256 "6fc08eea38b720145f9636bacf7b6bc1dbd45342451828303f4d64309445b51c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47d64d87afd0b215cfd921a3f38f559501454f97659791f8d990ac2c6320a7d3"
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
