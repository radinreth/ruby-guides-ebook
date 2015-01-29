..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_record_associations.epub active_record_associations.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_associations.epub active_record_associations.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_associations.epub active_record_associations.pdf

pause