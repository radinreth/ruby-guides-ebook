..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o ruby_on_rails_security_guide.epub ruby_on_rails_security_guide.md

..\..\..\..\..\tools\calibre\ebook-convert.exe ruby_on_rails_security_guide.epub ruby_on_rails_security_guide.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe ruby_on_rails_security_guide.epub ruby_on_rails_security_guide.pdf

pause