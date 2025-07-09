class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "a4dc3296747454ed04d0c7e96f67a90a293fdf0ec790037edb1ce63a6c55be62"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec41839edd303ff3504aacedd690b1a265b111cb7c544961e800988a38af7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccb02811bbda9e0331de048248432ec46af665146a9deaabc5adcee8cb168ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de61fe2440aab084aeba2aa389e8647139625b1ff385fc78525588f05e17e810"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bba4f8e9e2ea98d9acaf6f35d6c21cbc1c822246fa85178bb2c87bd6ba9b45f"
    sha256 cellar: :any_skip_relocation, ventura:       "4f2a51811846008a7df5a8d56e590502cb7294272caa84a5ef0be25756a23ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455ff0989a10e5450ce5f548942c19ebcaf080478c1c3996d4cf1d783983a0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02de3226e6b6f24ba01cc291887a35b98d5ba9aefdf92fb944a688d8f377a293"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"node").write <<~EOS
      #!/usr/bin/env dotslash

      // Example file from https://dotslash-cli.com/docs/.
      // The URLs in this file were taken from https://nodejs.org/dist/v18.19.0/

      {
        "name": "node-v18.19.0",
        "platforms": {
          "macos-aarch64": {
            "size": 40660307,
            "hash": "blake3",
            "digest": "6e2ca33951e586e7670016dd9e503d028454bf9249d5ff556347c3d98c347c34",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-arm64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-darwin-arm64.tar.gz"
              }
            ]
          },
          "macos-x86_64": {
            "size": 42202872,
            "hash": "blake3",
            "digest": "37521058114e7f71e0de3fe8042c8fa7908305e9115488c6c29b514f9cd2a24c",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-x64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-darwin-x64.tar.gz"
              }
            ]
          },
          "linux-aarch64": {
            "size": 44559104,
            "hash": "blake3",
            "digest": "bd605f5957f792def0885db18a9595202ba13f64d2e8d92514f95fb8c8ee5de5",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-arm64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-linux-arm64.tar.gz"
              }
            ]
          },
          "linux-x86_64": {
            "size": 44694523,
            "hash": "blake3",
            "digest": "72b81fc3a30b7bedc1a09a3fafc4478a1b02e5ebf0ad04ea15d23b3e9dc89212",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-x64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-linux-x64.tar.gz"
              }
            ]
          }
        }
      }
    EOS
    chmod 0755, testpath/"node"
    assert_match "v18.19.0", shell_output("#{testpath}/node -v")
  end
end
