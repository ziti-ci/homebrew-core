class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "da52e9c22357176fed44f7fb591d3a783911af3fed3c0f1cbf7c04b21b84738d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f43b4af4da330dfa3560c04a7e7efc724c170a429d539cc69dd2b33b05cc7d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc279786352d18d6e496a6414a73f3e5758296937090cd06a7f329204734da38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a524c98fd3c6deefdae513d51385af9ad62daee68c6ce9c1d9f0091d8e308e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a57366adcf54b1ce047d2287af0a26cd4beb6e6ffca6845d675fd27ce5331c"
    sha256 cellar: :any_skip_relocation, ventura:       "663de046c7f9b3fd31c6618bcf6961ba08e15404041ba993a1de7f95bcb748bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec40e107b8b7e5ca3258ed529920d482da0c7526f730d89a978b7fd43ff7cfcc"
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
