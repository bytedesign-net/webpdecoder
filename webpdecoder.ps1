$dateTime = Get-Date -Format "yyyy-MM-dd-HHmms"　#今日の日付
$scriptDir = $PSScriptRoot #スクリプトのカレントディレクトリパス
$dwebpFile = $scriptDir + '\libwebp\bin\dwebp.exe'#webpのデコードファイル
$settingsFile = $scriptDir + '\settings.json' #設定ファイル

#設定ファイルからログモードを取得
$json = ConvertFrom-Json -InputObject (Get-Content $settingsFile -Encoding UTF8 -Raw)
if ($json.logmode) {
    #ログ取得
    $logfilePath = $scriptDir + "\webpdecoder_" + $dateTime + ".log"
    Start-Transcript $logfilePath -Force | Out-Null
}

#設定ファイルから変換するファイル形式を取得
$fileType = $json.filetype

# 出力先のダイアログを表示
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{ 
    RootFolder = "MyComputer"
    Description = 'jpgファイルを保存するフォルダを選択してください'
}

if($FolderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
    #設定ファイルから出力するファイル形式を読み込み
    $dst = $FolderBrowser.SelectedPath + "`\"

    #バックアップの出力先のフォルダを作成
    $outputPath = $dst + "webpdecoder_" + $dateTime
    New-Item $outputPath -ItemType Directory -Force

    #(ショートカットにドラッグでwebpファイルを$argsに受けわたす)
    foreach ($arg in $args) {
        $webpFile = $arg
        Add-Type -AssemblyName System.Drawing
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($arg)

        #pngファイルのフルパスの文字列を作成 
        $pngFile = $outputPath + "`\" + $filename + ".png"
        #webpとpngファイルのフルパスを含めた引数の文字列を作成
        $ioFile = $webpFile + "` -o` " + $pngFile        
        #webp→png変換
        Start-Process -FilePath $dwebpFile -ArgumentList $ioFile

        if ($fileType -ne "png"){
            #出力ファイルのフルパスの文字列を作成 
            $outputFile = $outputPath + "`\" + $filename + "." + $fileType
            # 書き出しプロセスが終了するまで待機(ファイルロックエラーを回避)
            Wait-Process dwebp

            #png→jpg変換
            if($fileType -eq "jpg"){
                #設定ファイルからエンコードの品質を取得
                $qualityEncoder = [System.Drawing.Imaging.Encoder]::Quality
                $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
                $quality = $json.quality
                $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($qualityEncoder, $quality)
                $jpegCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | where {$_.MimeType -eq 'image/jpeg'}
                #ファイル書き出し
                $image = [System.Drawing.Image]::FromFile($pngFile)
                $image.Save($outputFile, $jpegCodecInfo, $encoderParams)
            }
            
            #png→jpg以外の変換
            else {
                #ファイル書き出し
                $image = [System.Drawing.Image]::FromFile($pngFile)
                $image.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::$fileType)
            }

            #オブジェクトの破棄
            $image.Dispose()
            #pngファイルを削除
            Remove-Item $pngFile
        }        
        echo "$filename.webpを$filename.$fileTypeに変換しました。"
    }
}
else {
    [System.Windows.MessageBox]::Show('フォルダは選択されませんでした')
}