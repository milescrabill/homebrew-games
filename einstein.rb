require 'formula'

class Einstein < Formula
  homepage 'http://web.archive.org/web/20120621005109/http://games.flowix.com/en/index.html'
  url 'http://web.archive.org/web/20120621005109/http://games.flowix.com/files/einstein/einstein-2.0-src.tar.gz'
  sha1 '866a9a1c115014d7f6a241bc22b251907f63f8bc'

  depends_on 'sdl'
  depends_on 'sdl_ttf'
  depends_on 'sdl_mixer'

  def patches
    # Fixes a cast error on compilation
    { :p0 => DATA }
  end

  def install
    system 'make'

    bin.install 'einstein'
    (share/'einstein/res').install 'einstein.res'
  end
end

__END__
--- formatter.cpp
+++ formatter.cpp
@@ -58,7 +58,7 @@ Formatter::Formatter(unsigned char *data, int offset)
             if ((c.type == INT_ARG) || (c.type == STRING_ARG) ||
                     (c.type == FLOAT_ARG) || (c.type == DOUBLE_ARG))
             {
-                int no = (int)c.data;
+                int no = *((int*)(&c.data));
                 args[no - 1] = c.type;
             }
         }
@@ -135,7 +135,7 @@ std::wstring Formatter::format(std::vector<ArgValue*> &argValues) const
                 
             case STRING_ARG:
             case INT_ARG:
-                no = (int)cmd->data - 1;
+                no = *((int*)(&cmd->data)) - 1;
                 if (no < (int)argValues.size())
                     s += argValues[no]->format(cmd);
                 break;
--- main.cpp
+++ main.cpp
@@ -61,13 +61,9 @@ static void loadResources(const std::wstring &selfPath)
 #ifdef WIN32
     dirs.push_back(getStorage()->get(L"path", L"") + L"\\res"); 
 #else
-#ifdef __APPLE__
-    dirs.push_back(getResourcesPath(selfPath));
-#else
     dirs.push_back(PREFIX L"/share/einstein/res");
     dirs.push_back(fromMbcs(getenv("HOME")) + L"/.einstein/res");
 #endif
-#endif
     dirs.push_back(L"res");
     dirs.push_back(L".");
     resources = new ResourcesCollection(dirs);

