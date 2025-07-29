class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "530d7754538632ff713b6642466999687cd5dc3f2cbd964b586e34657a30e149"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b55a87a97a617b5b3899e9cf2af2ae19147a09738926f39bfb4c1060f94aa6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a3e2c660aabf540034ce5d50c788daa0a2019a3ce08b40247b157e73ff0c36b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "538bf6f88a92a7d84ed68981f6bb19410988585fa6156ecddc7d4d1ccae54df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ceb0330b52e26674c51c6cf4e5fbeaa5dbc1e6eafe8ab0083d746eb72e57d2"
    sha256 cellar: :any_skip_relocation, ventura:       "e99c73a9b913d214bf111ccc9b3a72b4b9c26f6a5df5088f334d22e7416a1776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef2da5f525c1b7ebfb8d6f6e8d03f57306844b470e385ecb8344712f0439951"
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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
