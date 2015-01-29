..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_record_basics.epub active_record_basics.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_basics.epub active_record_basics.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_basics.epub active_record_basics.pdf

pause