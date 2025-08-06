class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2025-07-15.pem"
  sha256 "7430e90ee0cdca2d0f02b1ece46fbf255d5d0408111f009638e3b892d6ca089c"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cecefecd1faa4638190038aa023529cea2159dccdddcaf6d1a20e63d32cb4139"
  end

  def install
    pkgshare.install "cacert-#{version}.pem" => "cacert.pem"
  end

  def post_install
    if OS.mac?
      macos_post_install
    else
      linux_post_install
    end
  end

  def macos_post_install
    ohai "Regenerating CA certificate bundle from keychain, this may take a while..."

    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certificates_list = Utils.safe_popen_read("/usr/bin/security", "find-certificate", "-a", "-p", *keychains)
    certificates = certificates_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Check that the certificate has not expired
    valid_certificates = certificates.select do |certificate|
      begin
        Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                           "-checkend", "0",
                                                           "-noout") do |openssl_io|
          openssl_io.write(certificate)
        end
      rescue ErrorDuringExecution
        # Expired likely.
        next
      end

      # Only include certificates that are designed to act as a SSL root.
      purpose = Utils.safe_popen_write("/usr/bin/openssl", "x509", "-inform", "pem",
                                                                   "-purpose",
                                                                   "-noout") do |openssl_io|
        openssl_io.write(certificate)
      end
      purpose.include?("SSL server CA : Yes")
    end

    # Check that the certificate is trusted in keychain
    trusted_certificates = begin
      tmpfile = Tempfile.new

      verify_args = %W[
        -l -L
        -c #{tmpfile.path}
        -p ssl
      ]
      on_high_sierra :or_newer do
        verify_args << "-R" << "offline"
      end

      valid_certificates.select do |certificate|
        tmpfile.rewind
        tmpfile.write certificate
        tmpfile.truncate certificate.size
        tmpfile.flush
        Utils.safe_popen_read("/usr/bin/security", "verify-cert", *verify_args)
        true
      rescue ErrorDuringExecution
        # Invalid.
        false
      end
    ensure
      tmpfile&.close!
    end

    # Get SHA256 fingerprints for all trusted certificates
    fingerprints = trusted_certificates.to_set do |certificate|
      get_certificate_fingerprint(certificate, "/usr/bin/openssl")
    end

    # Now process Mozilla certificates we downloaded.
    pem_certificates_list = File.read(pkgshare/"cacert.pem")
    pem_certificates = pem_certificates_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    # Append anything new.
    trusted_certificates += pem_certificates.select do |certificate|
      fingerprint = get_certificate_fingerprint(certificate, "/usr/bin/openssl")
      fingerprints.add?(fingerprint)
    end

    pkgetc.mkpath
    (pkgetc/"cert.pem").atomic_write(trusted_certificates.join("\n") << "\n")
  end

  def get_certificate_fingerprint(certificate, openssl_binary = "openssl")
    Utils.safe_popen_write(openssl_binary, "x509", "-inform", "pem",
                                                   "-fingerprint",
                                                   "-sha256",
                                                   "-noout") do |openssl_io|
      openssl_io.write(certificate)
    end
  end

  def load_certificates_from_file(file_path, trusted_certificates, fingerprints, certificate_type)
    file_path = Pathname(file_path)
    return unless file_path.exist?

    certificates_list = file_path.read
    certificates = certificates_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )
    loaded_count = 0
    certificates.each do |certificate|
      fingerprint = get_certificate_fingerprint(certificate)
      if fingerprints.add?(fingerprint)
        trusted_certificates << certificate
        loaded_count += 1
      end
    rescue ErrorDuringExecution
      # Skip invalid certificate
      next
    end
    puts "Loaded #{loaded_count} #{certificate_type} certificates" if loaded_count.positive?
  end

  def linux_post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
    pkgetc.mkpath
    # Integrate system certificates if OpenSSL is available
    unless which("openssl")
      opoo "Cannot find OpenSSL: skipping system certificates."
      puts <<~EOS
        To include custom system certificates run:
          brew install openssl
          brew postinstall ca-certificates
      EOS
      cp pkgshare/"cacert.pem", pkgetc/"cert.pem"
      return
    end

    trusted_certificates = []
    fingerprints = Set.new

    # First, load system certificates from standard Linux location
    load_certificates_from_file("/etc/ssl/certs/ca-certificates.crt",
                                trusted_certificates, fingerprints, "system")

    # Now process Mozilla certs and append only new ones
    load_certificates_from_file(pkgshare/"cacert.pem", trusted_certificates, fingerprints, "Mozilla")

    (pkgetc/"cert.pem").atomic_write(trusted_certificates.join("\n") << "\n")
    ohai "CA certificates have been bootstrapped from the system CA store."
  end

  def caveats
    on_macos do
      <<~EOS
        CA certificates have been bootstrapped using certificates from the system keychain.
      EOS
    end

    on_linux do
      <<~EOS
        CA certificates have been bootstrapped from both the system CA store and the Mozilla CA store.
      EOS
    end
  end

  test do
    assert_path_exists pkgshare/"cacert.pem"
    assert_path_exists pkgetc/"cert.pem"
  end
end
