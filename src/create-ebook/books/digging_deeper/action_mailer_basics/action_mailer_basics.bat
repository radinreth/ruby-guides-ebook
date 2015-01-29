..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o action_mailer_basics.epub action_mailer_basics.md

..\..\..\..\..\tools\calibre\ebook-convert.exe action_mailer_basics.epub action_mailer_basics.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe action_mailer_basics.epub action_mailer_basics.pdf

pause