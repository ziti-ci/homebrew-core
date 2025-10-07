class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.13.3/flyway-commandline-11.13.3.tar.gz"
  sha256 "747bafddc19617c59413c6c16305677f0c2aa7f9f6ecf4c42a0fec8d0f1f9c4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cbd36f3ef8cea862b68109ebed196b03729bb850032aa1311e4aa5226aa22b5"
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
