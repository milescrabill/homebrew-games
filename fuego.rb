class Fuego < Formula
  homepage 'http://fuego.sourceforge.net/'
  head "http://svn.code.sf.net/p/fuego/code/trunk"
  url "http://svn.code.sf.net/p/fuego/code/trunk", :revision => 1981
  version "1.1.SVN"

  # automake should be a build dep, but won't install otherwise
  depends_on 'automake'
  depends_on 'boost'

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
