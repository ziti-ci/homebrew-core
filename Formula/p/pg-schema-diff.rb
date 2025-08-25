class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cb9ed31378e8b68864978975376d3bbb33f438d7747a114d00a2478dcae89dc0"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
