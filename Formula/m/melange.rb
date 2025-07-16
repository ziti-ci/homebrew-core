class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "7a783054705f5886cf574c4d1a9a335f5a7ad3d1fbbf24481af620e596356915"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "006a7d2ebde40fd50c487639114dfceb4762ee30119287b945d7cd788bec06cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbd370b4ddf4464d9617f9c2abb2d78434f5204d600eb92fc17e11639f438a58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e6e23539cb23d19484cbbb85ec8cbd3f7fc12d61409de0f8e2f2ed6ab754ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19aa98b22579626bbe8814da30bc1fc190e271c262e0910250559d0eb9c817b"
    sha256 cellar: :any_skip_relocation, ventura:       "11f1ca7e0c703005d10eb7e460bd6b7267e7ee06a237d9efed254077ff9a153f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce969b7486e84491c36afa2ed61c01043eb12c2cc3ffdde70e3ac8579dd163f"
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

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
