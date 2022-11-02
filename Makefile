# Copyright (c) 2021 Shahriar Nasim Nafi, MIT License
# https://github.com/snnafi/arabic-remove-diacrities-sqlite-extension

prepare-dist:
	rm -rf dist
	mkdir dist
	rm -rf generate
	mkdir generate

download-sqlite:
	curl -L https://www.sqlite.org/2022/sqlite-amalgamation-3390400.zip --output sqlite3.zip # change sql version if need
	unzip sqlite3.zip
	mv sqlite-amalgamation-3390400/* generate  # change sql version if need
	cp src/*.c generate
	rm -rf sqlite-amalgamation-3390400  # change sql version if need
	rm -rf sqlite3.zip


compile-linux:
	gcc -fPIC -shared generate/sqlite3-remove-arabic-diacritic.c -o dist/remove-arabic-diacritic.so

pack-linux:
	zip -j dist/remove-arabic-diacritic-linux-x86.zip dist/*.so

compile-windows:
	gcc -shared -I. generate/sqlite3-remove-arabic-diacritic.c -o dist/remove-arabic-diacritic.dll

pack-windows:
	7z a -tzip dist/remove-arabic-diacritic-win-x64.zip ./dist/*.dll

compile-macos:
	gcc -fPIC -dynamiclib -I generate generate/sqlite3-remove-arabic-diacritic.c -o dist/remove-arabic-diacritic.dylib

compile-macos-x86:
	mkdir -p dist/x86
	gcc -fPIC -dynamiclib -I generate src/sqlite3-remove-arabic-diacritic.c -o dist/x86/remove-arabic-diacritic.dylib -target x86_64-apple-macos10.12

compile-macos-arm64:
	mkdir -p dist/arm64
	gcc -fPIC -dynamiclib -I generate generate/sqlite3-remove-arabic-diacritic.c -o dist/arm64/remove-arabic-diacritic.dylib -target arm64-apple-macos11

pack-macos:
	zip -j dist/remove-arabic-diacritic-macos-x86.zip dist/x86/*.dylib
	zip -j dist/remove-arabic-diacritic-macos-arm64.zip dist/arm64/*.dylib

end-dist:
	rm -rf generate