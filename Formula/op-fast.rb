class OpFast < Formula
  desc "1Password CLI proxy for instant access to secrets."
  homepage "https://github.com/cometkim/op-fast"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.0/op-fast-aarch64-apple-darwin.tar.xz"
      sha256 "abfca3a47be3331f237cba0af2d171d69e9c0d156d5d05b51852443474b61192"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.0/op-fast-x86_64-apple-darwin.tar.xz"
      sha256 "1c42682009046afc3ae5d0604376bf6ac5af9e79986220a4b9b283ebf8e63ea5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.0/op-fast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff36bd10a951d8fccbaa1445b845fd78a4071ecc8ca97fad9235a211f9e66cc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cometkim/op-fast/releases/download/v0.1.0/op-fast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1fd42d3548a68a49e181029ddea9ce080472d3c303e5cb623383ea21ea4c6ee8"
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
