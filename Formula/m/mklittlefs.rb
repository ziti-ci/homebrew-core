class Mklittlefs < Formula
  desc "Creates LittleFS images for ESP8266, ESP32, Pico RP2040, and RP2350"
  homepage "https://github.com/earlephilhower/mklittlefs"
  url "https://github.com/earlephilhower/mklittlefs/releases/download/4.1.0/mklittlefs-source.zip"
  sha256 "4fa5565e2e9185898182557e25860f0fe5536f8133ef0247574105a75b5ae4d6"
  license "MIT"

  def install
    system "make", "BUILD_CONFIG_NAME=-#{version}"
    bin.install "mklittlefs"
  end

  test do
    mkdir (testpath/"data")
    (testpath/"data/hello.txt").write("Hello, World!")
    (testpath/"data/Poetry.txt").write("Had we but world enough, and time...")
    system(bin/"mklittlefs", "-s", "1048576", "-c", testpath/"data", testpath/"out.img")
    system(bin/"mklittlefs", "-u", testpath/"out", testpath/"out.img")
    system("diff", "-r", testpath/"data", testpath/"out")
  end
end
