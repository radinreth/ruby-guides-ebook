..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o action_controller_overview.epub action_controller_overview.md

..\..\..\..\..\tools\calibre\ebook-convert.exe action_controller_overview.epub action_controller_overview.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe action_controller_overview.epub action_controller_overview.pdf

pause