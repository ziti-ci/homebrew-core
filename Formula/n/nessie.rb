class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.9.tar.gz"
  sha256 "c07d6c8b4942e9a112d04c60a3ed45d29bd4dbb4cb136bcb80b1e631079877b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80527a0138f3dacd003c32345d67757bdc20fd4b5e013587704be3fd15088ec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "326d3e694a0cc971137c800efb340e448ea928891486568d2e59d6eadd39c575"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b637f4b14884a0908075940902e01e90ee968c32641dd1002624871c012751c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea6d01b16cdc65d908e6e06d7777a6095be83d08a1b042b7a2c451d7867e9d8"
    sha256 cellar: :any_skip_relocation, ventura:       "cddb3ff682c27060d0dded135d8fa4ee635ddd826bb523543fef1bd9f71a40e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f235bc073f9284a668db9163bb2472f1df7d75aa103482696d168d5bdd53135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc47ee49ff38bd2f3e6f526cfe744997d40218f4ea5736f90d4141680d9c609"
  end

  depends_on "gradle@8" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end
