class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "155ad17fb2d7021aac55563a3fd6e387ec893fac8de1d3378879e77b936a134e"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5830c4a45616551fe4dbf4aa0851ae33fb8cd4987b8ec7cba3b7a4e554b2fe74"
    sha256 cellar: :any,                 arm64_sonoma:  "e7d77c0c262799e5ee9c9367da015573157bffce666ce38a1669f488ee64aae2"
    sha256 cellar: :any,                 arm64_ventura: "e7ff5efa5b6617bf1024c2608394160fafce7e6666fbe801f2045d54612357f4"
    sha256 cellar: :any,                 sonoma:        "81cf33e75b001099077149eb1ddde2cc4520ea1e30e7c587f13453535a6dfc96"
    sha256 cellar: :any,                 ventura:       "6d37afff2e991924d7ef57523a775a04731e72c2dea684a17e13a6410b153bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0548bf9f35c4fa158a57cea0c34c6a24663fc211d7a6982d833697fcbc466c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706dd5fd982160de0b09ed654235f63f8830ad435f9a1a34815bd0efc251a7c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "Failed to find a Rust project", output
  end
end
