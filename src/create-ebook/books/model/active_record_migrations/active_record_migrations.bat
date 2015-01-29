..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_record_migrations.epub active_record_migrations.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_migrations.epub active_record_migrations.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_record_migrations.epub active_record_migrations.pdf

pause