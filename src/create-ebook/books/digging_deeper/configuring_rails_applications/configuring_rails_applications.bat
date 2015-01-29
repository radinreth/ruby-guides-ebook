..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o configuring_rails_applications.epub configuring_rails_applications.md

..\..\..\..\..\tools\calibre\ebook-convert.exe configuring_rails_applications.epub configuring_rails_applications.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe configuring_rails_applications.epub configuring_rails_applications.pdf

pause