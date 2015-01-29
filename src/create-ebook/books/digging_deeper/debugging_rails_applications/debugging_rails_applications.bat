..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o debugging_rails_applications.epub debugging_rails_applications.md

..\..\..\..\..\tools\calibre\ebook-convert.exe debugging_rails_applications.epub debugging_rails_applications.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe debugging_rails_applications.epub debugging_rails_applications.pdf

pause