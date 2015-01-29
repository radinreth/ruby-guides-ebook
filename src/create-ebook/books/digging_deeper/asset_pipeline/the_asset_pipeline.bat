..\..\..\..\..\tools\Pandoc\pandoc.exe --css '..\..\..\..\..\styles\tables.css' -o the_asset_pipeline.epub the_asset_pipeline.md

..\..\..\..\..\tools\calibre\ebook-convert.exe the_asset_pipeline.epub the_asset_pipeline.mobi

..\..\..\..\..\tools\calibre\ebook-convert.exe the_asset_pipeline.epub the_asset_pipeline.pdf

pause