..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o active_job_basics.epub active_job_basics.md

..\..\..\..\..\tools\calibre\ebook-convert.exe active_job_basics.epub active_job_basics.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe active_job_basics.epub active_job_basics.pdf

pause