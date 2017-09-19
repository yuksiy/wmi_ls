' ==============================================================================
'   機能
'     WMIマネージリソースを一覧表示する
'   構文
'     USAGE 参照
'
'   Copyright (c) 2012-2017 Yukio Shiiya
'
'   This software is released under the MIT License.
'   https://opensource.org/licenses/MIT
' ==============================================================================

'----------------------------------------------------------------------
' 基本設定
'----------------------------------------------------------------------
strHost = "."
Set objWMIService = GetObject("winmgmts://" & strHost & "/root/cimv2")

'----------------------------------------------------------------------
' 変数宣言 (スクリプトレベル変数)
'----------------------------------------------------------------------
' ユーザ変数

' Windows 依存変数

' プログラム内部変数

'----------------------------------------------------------------------
' 関数定義
'----------------------------------------------------------------------
Sub USAGE()
	WScript.StdErr.Write _
		"Usage: cscript.exe //nologo (install directory)\wmi_ls.vbs WMI_CLASS" & vbCrLf
End Sub

'----------------------------------------------------------------------
' メインルーチン
'----------------------------------------------------------------------

' 第1引数のチェック
If WScript.Arguments.Unnamed.Count < 1 Then
	WScript.StdErr.Write "-E Missing WMI_CLASS argument" & vbCrLf
	usage
	WScript.Quit(1)
Else
	wmi_class = WScript.Arguments.Unnamed.Item(0)
End If

' WMIクラスへの参照の取得
Set objClass = GetObject("winmgmts://" & strHost & "/root/cimv2:" & wmi_class)

' WMIクラスのインスタンスの取得
Set colItem = objWMIService.ExecQuery("Select * From " & wmi_class)

' ヘッダの出力
strRecord = ""
For Each objClassProperty In objClass.Properties_
	strClassPropertyName = objClassProperty.Name
	strRecord = strRecord & vbTab & strClassPropertyName
Next
' 先頭1文字のタブ文字を除去した結果を画面に出力
WScript.Echo Mid(strRecord, 2)

' 本文の出力
For Each objItem In colItem
	strRecord = ""
	For Each objClassProperty In objClass.Properties_
		strClassPropertyName = objClassProperty.Name
		Execute "strClassPropertyValue = objItem."  & strClassPropertyName
		' strClassPropertyValue中の全ての改行文字を除去
		If strClassPropertyValue <> "" Then
			strClassPropertyValue = Replace(strClassPropertyValue, vbNewLine, "")
		End If
		strRecord = strRecord & vbTab & strClassPropertyValue
	Next
	' 先頭1文字のタブ文字を除去した結果を画面に出力
	WScript.Echo Mid(strRecord, 2)
Next

