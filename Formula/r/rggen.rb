class Rggen < Formula
  desc "Code generation tool for control and status registers"
  homepage "https://github.com/rggen/rggen"
  license "MIT"

  stable do
    url "https://github.com/rggen/rggen.git",
      tag:      "v0.35.2",
      revision: "7c90c80913e39efa838ecdf05d95214dbb1f2d94"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        tag:      "v0.13.2",
        revision: "07128f7c93bf0ac273b6e5eaa516544fd95ab87a"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        tag:      "v0.5.2",
        revision: "766447aa7d23211644c15064329f0f8f60d210f4"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        tag:      "v0.12.2",
        revision: "b65b5cd6db9926b6d2e589bcdd208b0ad5fce9e2"
    end
  end

  head do
    url "https://github.com/rggen/rggen.git",
      branch: "master"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        branch: "master"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        branch: "master"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        branch: "master"
    end
  end

  # Requires Ruby >= 3.1
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    %w[rggen-verilog rggen-veryl rggen-vhdl].each do |plugin|
      resource(plugin).stage do
        system "gem", "build", "#{plugin}.gemspec"
        system "gem", "install", "#{plugin}-#{resource(plugin).version}.gem"
      end
    end

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    test_file = testpath/"test.toml"
    test_file.write <<~EOF
      [[register_blocks]]
      name      = 'test'
      byte_size = 1
      bus_width = 8
      [[register_blocks.registers]]
      name = 'test_register'
      [[register_blocks.registers.bit_fields]]
      name           = 'test_rw_field'
      bit_assignment = { width = 6 }
      type           = 'rw'
      initial_value  = 0
      [[register_blocks.registers.bit_fields]]
      name           = 'test_res_fieldres'
      bit_assignment = { width = 2 }
      type           = 'reserved'
    EOF

    command = "#{bin}/rggen --plugin rggen-vhdl --plugin rggen-verilog --plugin rggen-veryl --load-only #{test_file}"
    assert_empty shell_output(command).strip
  end
end
