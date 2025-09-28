class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  stable do
    url "https://github.com/sstadick/perbase/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "6b9e030ce0692631482ef074a7d6c37519d6400be21d2f7533ba44a0ec5dc237"

    uses_from_macos "xz" => :build
    uses_from_macos "curl"
    uses_from_macos "zlib"

    # Resource to avoid building bundled curl, xz and zlib-ng
    # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
    resource "hts-sys" do
      url "https://static.crates.io/crates/hts-sys/hts-sys-2.1.1.crate"
      sha256 "deebfb779c734d542e7f14c298597914b9b5425e4089aef482eacb5cab941915"

      livecheck do
        url "https://raw.githubusercontent.com/sstadick/perbase/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
        regex(/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb372e69ea48b07aad48b2cd16ff196464553101ad6c733729562923548a806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b4e4b6a8bde8efb516cc81688eafefd9ace4cc2759f315713f32af2221e7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d585cde8edf189742687519dfd326902b16de1e16f1eac67620dd68cb96d50b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c332dbefe601d6b26675c09d6150b7dfedc50a13f106cf68507acc6d1e4f211"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dfe32666a0e0233d79152879bddb5bbd400efcd646514519ff387ca7c78f1c6"
    sha256 cellar: :any_skip_relocation, ventura:       "aeb69abd269e393ed75a2dcabf50ec2063da579c4c5b0d4d04a084e3833a4d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e9dc64b2d55b9cd7c77c5aecad6cd213c79b70e8824002c04384124f28f54a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    if build.stable?
      # TODO: remove this check when bump-formula-pr can automatically update resources
      hts_sys_version = File.read("Cargo.lock")[/name = "hts-sys"\nversion = "(\d+(?:\.\d+)+)"/i, 1]
      odie "Resource `hts-sys` version needs to be updated!" if resource("hts-sys").version != hts_sys_version

      # Workaround to disable building bundled zlib-ng in "gzp -> flate2"
      inreplace "Cargo.toml",
                /^(gzp = )("[\d.]+")$/,
                '\1{ version = \2, default-features = false, features = ["deflate_zlib", "libdeflate"] }'

      # Workaround to disable building bundled curl, xz and zlib-ng in "rust-htslib -> hts-sys"
      resource("hts-sys").stage(buildpath/"hts-sys")
      inreplace "hts-sys/Cargo.toml" do |s|
        s.gsub!(/^features = \[\s*"static-curl",\s*"static-ssl",/, "features = [")
        s.gsub!(/^features = \[\s*"static"\s*\]$/, "")
        s.gsub!(/^features = \[\s*"zlib-ng",\s*"static",\s*\]$/, "")
      end
      args = %w[--config patch.crates-io.hts-sys.path="hts-sys"]
    end

    system "cargo", "install", *args, *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
