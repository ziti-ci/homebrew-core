class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.3.0/source.tar.gz"
  sha256 "45d112673c633684459651976119fcb4d8a7f1a74b974ad05de61481b686f49b"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = Formula["z3"].opt_lib
    ENV["Z3_SYS_Z3_HEADER"] = Formula["z3"].opt_include
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wuppiefuzz version")

    (testpath/"openapi.yaml").write <<~YAML
      openapi: 3.0.0
    YAML

    output = shell_output("#{bin}/wuppiefuzz fuzz openapi.yaml 2>&1", 1)
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end
