class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "cba0e1a7c591bfc09b265c527cf2b4408acfa4983e1db6e1fc65f4fd0319a462"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ce2ef89db1ad0b0660f3a1502786a1612249c563edf02c2d6dfd24b9e601ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ce2ef89db1ad0b0660f3a1502786a1612249c563edf02c2d6dfd24b9e601ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ce2ef89db1ad0b0660f3a1502786a1612249c563edf02c2d6dfd24b9e601ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "386c7b615e8b2d93778c79ec0f1b0b1e8200d35e1b0bdb9a7a7d6ceef8752ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049750cd4436a7aca3fc892767479a2083b821cf9023beda1b51fd926ec733e9"
  end

  depends_on "go" => :build

  def install
    project = "github.com/GoogleContainerTools/container-structure-test"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.version=#{version}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-structure-test"
  end

  test do
    # Small Docker image to run tests against
    resource "homebrew-test_resource" do
      url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
      sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
    end

    (testpath/"test.yml").write <<~YAML
      schemaVersion: "2.0.0"

      fileContentTests:
        - name: root user
          path: "/etc/passwd"
          expectedContents:
            - "root:x:0:0:root:/root:/bin/sh\\n.*"

      fileExistenceTests:
        - name: Basic executable
          path: /bin/test
          shouldExist: yes
          permissions: '-rwxr-xr-x'
    YAML

    args = %w[
      --driver tar
      --json
      --image busybox-1.31.1.tar
      --config test.yml
    ].join(" ")

    resource("homebrew-test_resource").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end
