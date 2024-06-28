class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.8.0.tar.gz"
  sha256 "251ab981449209550b88bdab08ba108c104f430680b9a1ab2eb81a62bb0082d1"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "786c5c4c151874f58ef3760bf9e1b38b102f8729e9b3984550d4c57363813dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "786c5c4c151874f58ef3760bf9e1b38b102f8729e9b3984550d4c57363813dde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786c5c4c151874f58ef3760bf9e1b38b102f8729e9b3984550d4c57363813dde"
    sha256 cellar: :any_skip_relocation, sonoma:         "401bb5f98611323e0065da3a02fa68397bef777a00e54227832935dd87cc80f7"
    sha256 cellar: :any_skip_relocation, ventura:        "401bb5f98611323e0065da3a02fa68397bef777a00e54227832935dd87cc80f7"
    sha256 cellar: :any_skip_relocation, monterey:       "401bb5f98611323e0065da3a02fa68397bef777a00e54227832935dd87cc80f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7320100c4cfd7d95e90c74cb3e69cdc6190dec54cd9ffdb1daa0193b868219c2"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
