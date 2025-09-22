class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.143.0.tar.gz"
  sha256 "4cdf2fc792f62faf60b07d29190bc9ec4a9c9ac6de2b279c6af6b626125606a4"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6213e4b01703a30a2f6d9cafa6471f2191c27cfa56e977ca37ce6d497a08ff2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6213e4b01703a30a2f6d9cafa6471f2191c27cfa56e977ca37ce6d497a08ff2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6213e4b01703a30a2f6d9cafa6471f2191c27cfa56e977ca37ce6d497a08ff2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6213e4b01703a30a2f6d9cafa6471f2191c27cfa56e977ca37ce6d497a08ff2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d40a6a885a01cb22f68c1bb018e26d2b8a30ca1b66b40150c376b5bd4cb6d8c5"
    sha256 cellar: :any_skip_relocation, ventura:       "d40a6a885a01cb22f68c1bb018e26d2b8a30ca1b66b40150c376b5bd4cb6d8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce85bddefd490d162a9aca1c518593d3bde0a9d4f0764259ea84485085b0bce2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
