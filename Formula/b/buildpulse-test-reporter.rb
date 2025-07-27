class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "605e87f4d566f14455f6c1e609eabd3fc2337a09d695fafc489011ce48b02035"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3e526cd4bab198e54e8c9fe74f399236a7acd7e367e3cd256bc76d9b32682d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3e526cd4bab198e54e8c9fe74f399236a7acd7e367e3cd256bc76d9b32682d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb3e526cd4bab198e54e8c9fe74f399236a7acd7e367e3cd256bc76d9b32682d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5fac61ab3bdf6a12a4e4f6bebea5c28b84af09d9669b8179cf9562b8181f98"
    sha256 cellar: :any_skip_relocation, ventura:       "ce5fac61ab3bdf6a12a4e4f6bebea5c28b84af09d9669b8179cf9562b8181f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c223352eed836b439d1ab44e7f3d807f738a1f762d095e7f51f7644a53fa1a"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
