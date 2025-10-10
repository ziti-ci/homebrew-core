class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "42c10a83db4bb9a3bc761c2cf83be25376865c3210b08af4a6c78d568a1c5de0"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb686038cabae2ce6c8dcbbef8d91a120377a12d6986dc5acb2e711eb90129f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb686038cabae2ce6c8dcbbef8d91a120377a12d6986dc5acb2e711eb90129f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb686038cabae2ce6c8dcbbef8d91a120377a12d6986dc5acb2e711eb90129f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f502ec29baca4bbb5aacb7f2df44926df818a9d1df35ee191e384c929fa59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622bbd60eaf40f79912b7ae12140c92b1e1db3f79f482c0bd7c7f5a89e95abb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vals version")

    (testpath/"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}/vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath/"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}/vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end
