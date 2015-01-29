..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o layouts_and_rendering_in_rails.epub layouts_and_rendering_in_rails.md

..\..\..\..\..\tools\calibre\ebook-convert.exe layouts_and_rendering_in_rails.epub layouts_and_rendering_in_rails.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe layouts_and_rendering_in_rails.epub layouts_and_rendering_in_rails.pdf

pause