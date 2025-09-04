class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.12.0/flyway-commandline-11.12.0.tar.gz"
  sha256 "6863a7e26a5142e798ec5d754770e738d217015d8b19dc37fa84de6439d219aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7924e5e63d2084fc2c8e8a89eba5dad46db26a54d750413452d9681498a23952"
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
