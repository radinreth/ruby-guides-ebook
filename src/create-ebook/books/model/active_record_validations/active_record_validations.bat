..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_record_validations.epub active_record_validations.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_validations.epub active_record_validations.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_validations.epub active_record_validations.pdf

pause