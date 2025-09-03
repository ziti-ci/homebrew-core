class Uvwasi < Formula
  desc "WASI syscall API built atop libuv"
  homepage "https://github.com/nodejs/uvwasi"
  license "MIT"
  head "https://github.com/nodejs/uvwasi.git", branch: "main"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/nodejs/uvwasi/archive/refs/tags/v0.0.22.tar.gz"
    sha256 "255b5d4b961ab73ac00d10909cd2a431670fc708004421f07267e8d6ef8a1bc8"

    # Ensure all symbols required by Node are exported.
    # https://github.com/nodejs/uvwasi/pull/311
    patch do
      url "https://github.com/nodejs/uvwasi/commit/7803a3183b4ed3ab975311eeb014365e56a85950.patch?full_index=1"
      sha256 "736e47f765c63316bb99af6599219780822d1ba708a96bfe9ae1176ad2ca6c43"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1301aacda0bff9a5b103cde120e19aaac78ffbe5f09705b1c1d2325bd4be626"
    sha256 cellar: :any,                 arm64_sonoma:  "80082a287224d9ecfa860812342997f6a628a3dd286357220bf61e90ff8ed2ba"
    sha256 cellar: :any,                 arm64_ventura: "b3158be5a25f98230d95aea8795e5b58fd165bd85284392f172c6c57412ae954"
    sha256 cellar: :any,                 sonoma:        "066b2018420140f16dde996fb33d354f2452365882bb86298ec2d88019b9ec80"
    sha256 cellar: :any,                 ventura:       "055ffa830b53b3aeb6c491b173df544a32b2747d95cb0799870b04008880117e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a42e7a904d8a5378a7ce378cc3662334bb6e779b16fe96d951824a1e219e26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e9282ff7b6fb954ae33c4d63fad37e38fc72f7f593957fe1896e02d1488bd4"
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Adapted from "Example Usage" in README.
    (testpath/"test-uvwasi.c").write <<~C
      #include <stdlib.h>
      #include <string.h>
      #include "uv.h"
      #include "uvwasi.h"

      int main(void) {
        uvwasi_t uvwasi;
        uvwasi_options_t init_options;
        uvwasi_errno_t err;

        memset(&init_options, 0, sizeof(init_options));

        /* Setup the initialization options. */
        init_options.in = 0;
        init_options.out = 1;
        init_options.err = 2;
        init_options.fd_table_size = 4;

        init_options.argc = 1;
        init_options.argv = calloc(init_options.argc, sizeof(char*));
        init_options.argv[0] = strdup("test-uvwasi");

        init_options.envp = calloc(1, sizeof(char*));
        init_options.envp[0] = NULL;

        init_options.preopenc = 1;
        init_options.preopens = calloc(1, sizeof(uvwasi_preopen_t));
        init_options.preopens[0].mapped_path = strdup("/sandbox");
        init_options.preopens[0].real_path = strdup("/tmp");

        init_options.allocator = NULL;

        /* Initialize the sandbox. */
        err = uvwasi_init(&uvwasi, &init_options);

        if (err != UVWASI_ESUCCESS) {
          fprintf(stderr, "uvwasi_init() failed: %d\\n", err);
          return 1;
        }

        /* Clean up resources. */
        uvwasi_destroy(&uvwasi);
        return 0;
      }
    C

    ENV.append_to_cflags "-I#{include} -I#{Formula["libuv"].opt_include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-luvwasi"

    system "make", "test-uvwasi"
    system "./test-uvwasi"
  end
end
