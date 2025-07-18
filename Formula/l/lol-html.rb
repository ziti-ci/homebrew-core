class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "f08f859b6c3765bf4dc6998e9407851f67e2517b32435205ab3fe94137c0803e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a5bf511b0e79fafebf68e51d8d70ce2849b7cac56441234176b45b0d4283984"
    sha256 cellar: :any,                 arm64_sonoma:  "b1071b1948acd68a50e8cb9f119533de8417bbc5ec0faa1c53fdd47e83ffe93e"
    sha256 cellar: :any,                 arm64_ventura: "adca8690479cc493a5d8faccec5325382dceddef1700cfe0d1c2063d093ac280"
    sha256 cellar: :any,                 sonoma:        "441869e3e8e1c9807844c36e7cd0e21d25d2f4c753374554c6835bbc9d6448fd"
    sha256 cellar: :any,                 ventura:       "5b06c440efeee13f08a8560fc990c1c2ee960f75e77537e4ea471f478615f70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2095241f8b34ccc99cb2db8fa903a96348508638aadb468b4f89a79e9408d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17393e6b70e0c070a3b363e44466bb4fa6f767936604c601c5aaae4a58381f87"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  # patch Cargo.lock, upstream has already updated it
  patch :DATA

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lol_html.h>

      int main() {
        lol_html_str_t err = lol_html_take_last_error();
        if (err.data == NULL && err.len == 0) {
          return 0;
        }

        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs lol-html").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/c-api/Cargo.lock b/c-api/Cargo.lock
index 3bcaea8..a6458b1 100644
--- a/c-api/Cargo.lock
+++ b/c-api/Cargo.lock
@@ -51,9 +51,18 @@ dependencies = [

 [[package]]
 name = "derive_more"
-version = "0.99.20"
+version = "2.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6edb4b64a43d977b8e99788fe3a04d483834fba1215a7e02caa415b626497f7f"
+checksum = "093242cf7570c207c83073cf82f79706fe7b8317e98620a47d5be7c3d8497678"
+dependencies = [
+ "derive_more-impl",
+]
+
+[[package]]
+name = "derive_more-impl"
+version = "2.0.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "bda628edc44c4bb645fbe0f758797143e4e07926f7ebf4e9bdfbd3d2ce621df3"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -136,7 +145,7 @@ checksum = "13dc2df351e3202783a1fe0d44375f7295ffb4049267b0f3018346dc122a1d94"

 [[package]]
 name = "lol_html"
-version = "2.5.0"
+version = "2.6.0"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -271,9 +280,9 @@ checksum = "ec0be4795e2f6a28069bec0b5ff3e2ac9bafc99e6a9a7dc3547996c5c816922c"

 [[package]]
 name = "selectors"
-version = "0.27.0"
+version = "0.30.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5b75e048a93e14929e68e37b82e207db957cbb368375a80ed3ca28ac75080856"
+checksum = "3df44ba8a7ca7a4d28c589e04f526266ed76b6cc556e33fe69fa25de31939a65"
 dependencies = [
  "bitflags",
  "cssparser",
