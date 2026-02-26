class OpFast < Formula
  desc "1Password CLI proxy for instant access to secrets"
  homepage "https://github.com/cometkim/op-fast"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.1/op-fast-aarch64-apple-darwin.tar.xz"
      sha256 "6b20f4fc651ac73228a503ee5e3e121ad88c2d943d04037d6de6cfe0b87e6e6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.1/op-fast-x86_64-apple-darwin.tar.xz"
      sha256 "8bad625e12e8e87d4989b9c532f7ee3bffaf5d8ee582d7531eb8fe33aee03b83"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.1/op-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "59622b22f76fe1ff54fec06dc214b192b6878cf6dd596a972f11e9a7d1461ca5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.1/op-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a480a09ef344b7503a26f3b173891350a4d3bc465f6dcdd7b0f51735554c65f8"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "op-fast" if OS.mac? && Hardware::CPU.arm?
    bin.install "op-fast" if OS.mac? && Hardware::CPU.intel?
    bin.install "op-fast" if OS.linux? && Hardware::CPU.arm?
    bin.install "op-fast" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
