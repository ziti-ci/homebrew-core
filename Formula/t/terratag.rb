class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ae27b37043126bd18271e157018fc49b826fdbe8346d2074dddc83bf771c8e6b"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terratag"
  end

  test do
    (testpath/"main.tf").write <<~EOS
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    EOS

    system bin/"terratag", "-dir", testpath.to_s, "-tags", '{"environment":"test","owner":"brew"}',
                           "-rename=false"

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1")

    assert_match "terraform init must run before running terratag", output
  end
end
