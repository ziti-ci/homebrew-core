class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.15.0.tar.gz"
  sha256 "00040ef20d25918eafd5e89e8c237d5a647810efb1466677fbe0cbb766213f7c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dc1ebee43a413ff538556287184840f7027061463db99a1d5a9f7b94db935db"
    sha256 cellar: :any,                 arm64_sequoia: "7ec816ce235a93c74d39a8865a4958445c85753fd7edc3e6d485ce50e4193941"
    sha256 cellar: :any,                 arm64_sonoma:  "727a06e1a96a61606f4a7c90ba08d3d1e4a617d936a2524004be965db1f9b3ba"
    sha256 cellar: :any,                 sonoma:        "a5ab39bfe79d08ec421c498a09ed36cc74577901ee3d8c9b91b21102a38ea31b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f39affa8dd0f64e8b75cdda670cb8cb9dd15682ece38f99417b913c53eba54e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5ed81e6af3047e2e4aaa390bd579021667d8a116ba4f345f981fdc9ff9ef65"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "azure-storage-common-cpp"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/storage/azure-storage-blobs", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-blobs/test/ut/simplified_header_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <azure/storage/blobs.hpp>

      int main() {
        Azure::Storage::Blobs::BlobServiceClient serviceClient("https://account.blob.core.windows.net");
        Azure::Storage::Blobs::BlobContainerClient containerClient(
            "https://account.blob.core.windows.net/container");
        Azure::Storage::Blobs::BlobClient blobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlockBlobClient blockBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::PageBlobClient pageBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::AppendBlobClient appendBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlobLeaseClient leaseClient(
            containerClient, Azure::Storage::Blobs::BlobLeaseClient::CreateUniqueLeaseId());

        Azure::Storage::Sas::BlobSasBuilder sasBuilder;

        Azure::Storage::StorageSharedKeyCredential keyCredential("account", "key");
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lazure-storage-blobs",
                    "-L#{Formula["azure-core-cpp"].opt_lib}", "-lazure-core"
    system "./test"
  end
end
