# webpdecoder

webpdecoderはwebpファイルを他の画像形式に変換するツールです。

# DEMO

"hoge"の魅力が直感的に伝えわるデモ動画や図解を載せる

# Features

- 単一または複数のwebpファイルを一括して.bmp, gif, jpg, png, tiffに変換して出力します。
- 作成したショートカットにドラッグアンドドロップし、任意の保存先に保存します。
- jpgファイルの圧縮後の画質を設定できます。
- jpgファイルはPhotoshopでも使用可能(「要求された操作を完了できません。プログラムエラーです。」のエラーに対応しました)

# Requirement

* PowerShell 5.x(Windows10 x64)

# Installation

1. webpdecoder(ディレクトリごと)を任意の場所に保存
2. webpdecoder.ps1のショートカットを任意の場所に作成
3. ショートカットのリンク先の最初に"powershell -NoProfile -File "を先頭に追記
    例）powershell -NoProfile -File C:\Users\(ユーザー名)\Desktop\webp2jpg\webpdecoder.ps1

# Usage

1. settings.jsonので変換の設定を行う
    - "logmode":  true --webpdecoder.ps1と同じ場所にログを書き出します。(設定値[true, false] デフォルト: false)
    - "filetype": "jpg" --変換後のファイル形式を指定します。(設定値[bmp, gif, jpg, png, tiff] デフォルト: jpg)
    - "quality": 100 --jpg圧縮後の画質を指定します。(設定値[0 - 100])
2. webpファイルをショートカットにドラッグアンドドロップ
3. ダイアログで保存先を指定

# Note

ファイル名に[ , $, ? ", ', (, ), |, %, ., +, =, !, `, <, >, &, {, }, @]が含まれているものは変換できません。

# Author

* hondaluigi@curledtail
* https://curl-t.com

# License

"webpdecoder" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
"WebP Converter" is under (https://www.webmproject.org/license/software/)