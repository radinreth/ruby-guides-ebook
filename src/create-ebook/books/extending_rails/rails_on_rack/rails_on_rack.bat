..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o rails_on_rack.epub rails_on_rack.md

..\..\..\..\..\tools\calibre\ebook-convert.exe rails_on_rack.epub rails_on_rack.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe rails_on_rack.epub rails_on_rack.pdf

pause