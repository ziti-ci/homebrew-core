class Clipper2 < Formula
  desc "Polygon clipping and offsetting library"
  homepage "https://github.com/AngusJohnson/Clipper2"
  url "https://github.com/AngusJohnson/Clipper2/releases/download/Clipper2_1.5.4/Clipper2_1.5.4.zip"
  sha256 "e5cbe4acdfbd381496feacd5692110f60914ce2998e7350b124fb11429574f75"
  license "BSL-1.0"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCLIPPER2_EXAMPLES=OFF
      -DCLIPPER2_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", "CPP", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "CPP/Examples/SimpleClipping/SimpleClipping.cpp" do |s|
      s.gsub! "\"clipper2/clipper.h\"", "<clipper2/clipper.h>"
      s.gsub! "\"../../Utils/clipper.svg.utils.h\"", "\"clipper.svg.utils.h\""
      s.gsub!(/System\(".*"\);/, "")
    end

    inreplace "CPP/Utils/clipper.svg.utils.h", "\"clipper.svg.h\"", "<clipper2/Utils/clipper.svg.h>"

    pkgshare.install "CPP/Examples/SimpleClipping/SimpleClipping.cpp", "CPP/Utils/clipper.svg.utils.h"
  end

  test do
    system ENV.cxx, pkgshare/"SimpleClipping.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}",
                    "-lClipper2", "-lClipper2utils",
                    "-o", "test"
    system "./test"
    refute_empty (testpath/"solution.svg").read
  end
end
