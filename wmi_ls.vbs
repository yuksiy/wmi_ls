' ==============================================================================
'   �@�\
'     WMI�}�l�[�W���\�[�X���ꗗ�\������
'   �\��
'     USAGE �Q��
'
'   Copyright (c) 2012-2017 Yukio Shiiya
'
'   This software is released under the MIT License.
'   https://opensource.org/licenses/MIT
' ==============================================================================

'----------------------------------------------------------------------
' ��{�ݒ�
'----------------------------------------------------------------------
strHost = "."
Set objWMIService = GetObject("winmgmts://" & strHost & "/root/cimv2")

'----------------------------------------------------------------------
' �ϐ��錾 (�X�N���v�g���x���ϐ�)
'----------------------------------------------------------------------
' ���[�U�ϐ�

' Windows �ˑ��ϐ�

' �v���O���������ϐ�

'----------------------------------------------------------------------
' �֐���`
'----------------------------------------------------------------------
Sub USAGE()
	WScript.StdErr.Write _
		"Usage: cscript.exe //nologo (install directory)\wmi_ls.vbs WMI_CLASS" & vbCrLf
End Sub

'----------------------------------------------------------------------
' ���C�����[�`��
'----------------------------------------------------------------------

' ��1�����̃`�F�b�N
If WScript.Arguments.Unnamed.Count < 1 Then
	WScript.StdErr.Write "-E Missing WMI_CLASS argument" & vbCrLf
	usage
	WScript.Quit(1)
Else
	wmi_class = WScript.Arguments.Unnamed.Item(0)
End If

' WMI�N���X�ւ̎Q�Ƃ̎擾
Set objClass = GetObject("winmgmts://" & strHost & "/root/cimv2:" & wmi_class)

' WMI�N���X�̃C���X�^���X�̎擾
Set colItem = objWMIService.ExecQuery("Select * From " & wmi_class)

' �w�b�_�̏o��
strRecord = ""
For Each objClassProperty In objClass.Properties_
	strClassPropertyName = objClassProperty.Name
	strRecord = strRecord & vbTab & strClassPropertyName
Next
' �擪1�����̃^�u�����������������ʂ���ʂɏo��
WScript.Echo Mid(strRecord, 2)

' �{���̏o��
For Each objItem In colItem
	strRecord = ""
	For Each objClassProperty In objClass.Properties_
		strClassPropertyName = objClassProperty.Name
		Execute "strClassPropertyValue = objItem."  & strClassPropertyName
		' strClassPropertyValue���̑S�Ẳ��s����������
		If strClassPropertyValue <> "" Then
			strClassPropertyValue = Replace(strClassPropertyValue, vbNewLine, "")
		End If
		strRecord = strRecord & vbTab & strClassPropertyValue
	Next
	' �擪1�����̃^�u�����������������ʂ���ʂɏo��
	WScript.Echo Mid(strRecord, 2)
Next

