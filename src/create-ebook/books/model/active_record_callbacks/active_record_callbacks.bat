..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_record_callbacks.epub active_record_callbacks.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_callbacks.epub active_record_callbacks.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_callbacks.epub active_record_callbacks.pdf

pause