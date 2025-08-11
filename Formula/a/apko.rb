class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "6d32c7e36f3d7e1f7daa563a282158ae44ac6fa1c977634edf5a8fb2dc50811b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8c988cc427af98016a2c607377ba64ddf3c2fdf8386fbef159d936d6522b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "666c272865dce32835c39f1725b5edb8a0b4954ca0c972caf0a5dc7ed0a9178c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82a9ed95cf6332aa69fa99d93d35834320beb43b73733a13b704c89718a678da"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dabce75bdc230760fa8921817c04cd86049179596eb9aa979bb0b1f58774941"
    sha256 cellar: :any_skip_relocation, ventura:       "6e8d6c1a99477bef2fcaf83f95abd5860d84d107b75ff5b4277536aafd5abf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9dc3d69f1dafaa4e55b769028d32f9198c4d1bb7cbee016d6c86e2872ac627"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end
