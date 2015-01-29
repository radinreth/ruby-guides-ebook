..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o form_helpers.epub form_helpers.md

..\..\..\..\..\tools\calibre\ebook-convert.exe form_helpers.epub form_helpers.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe form_helpers.epub form_helpers.pdf

pause