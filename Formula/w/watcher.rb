class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.7.tar.gz"
    sha256 "d9b65ba4aaba325d113fc0a307c9cc297a09eaf72de0c22496a4848aea9a2893"

    # Fix generation of `.pc` files.
    # https://github.com/e-dant/watcher/pull/90
    patch do
      url "https://github.com/e-dant/watcher/commit/de05a8c4d1cbeb4fa3e5db388603853889db8910.patch?full_index=1"
      sha256 "86c1f4d366d5ab314a1a96a8966d12ccb46902b924dd6362ddb47ab1859681d7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88978779d9adbd52e905797fec0b4296311ee45195da68bb30b3cf2cae2e5304"
    sha256 cellar: :any,                 arm64_sonoma:  "0bd14316c193f1d22a1a451dde171daa584e19ba26cb9fd8cad208db66a03659"
    sha256 cellar: :any,                 arm64_ventura: "772f477fa33808b9e6dea70dd856b140d52501f2141ca72dab8bdafe400cb427"
    sha256 cellar: :any,                 sonoma:        "9573d3e116e14794c643713d96e2a79108b4c975857a15c9cfc79047d19ac719"
    sha256 cellar: :any,                 ventura:       "1bc722937041a74ebe2c5252c99915c6256c232513f8bd2e53bfe92f4b4ea331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e68690c3f5f4d60ce4b91f927cffdc933cf057791097f9528f63b9e47119202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8faf66477436e091e9f8163911151a3cbb8ba2a8bfe82e49588a164b6336ac55"
  end

  depends_on "cmake" => :build

  conflicts_with "tabiew", because: "both install `tw` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/wtr.watcher . -ms 1")
    assert_match "create", output
    assert_match "destroy", output

    (testpath/"test.c").write <<~C
      #include <wtr/watcher-c.h>
      #include <stdio.h>

      void callback(struct wtr_watcher_event event, void* _ctx) {
          printf(
              "path name: %s, effect type: %d path type: %d, effect time: %lld, associated path name: %s\\n",
              event.path_name,
              event.effect_type,
              event.path_type,
              event.effect_time,
              event.associated_path_name ? event.associated_path_name : ""
          );
      }

      int main() {
          void* watcher = wtr_watcher_open(".", callback, NULL);
          wtr_watcher_close(watcher);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwatcher-c", "-o", "test"
    system "./test"
  end
end
