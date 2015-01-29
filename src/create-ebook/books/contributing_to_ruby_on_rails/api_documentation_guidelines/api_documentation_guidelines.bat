..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o api_documentation_guidelines.epub api_documentation_guidelines.md

..\..\..\..\..\tools\calibre\ebook-convert.exe api_documentation_guidelines.epub api_documentation_guidelines.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe api_documentation_guidelines.epub api_documentation_guidelines.pdf

pause