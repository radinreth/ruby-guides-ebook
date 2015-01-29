..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o ruby_on_rails_guides_guidelines.epub ruby_on_rails_guides_guidelines.md

..\..\..\..\..\tools\calibre\ebook-convert.exe ruby_on_rails_guides_guidelines.epub ruby_on_rails_guides_guidelines.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe ruby_on_rails_guides_guidelines.epub ruby_on_rails_guides_guidelines.pdf

pause