Attribute VB_Name = "mod_Variables"
Option Explicit
'=========================================================='
'Thanks to: Planet Source Code wwww.planet-source-code.com '
'Date     : 25-06-2004                                     '
'Name     : mod_Variables.bas                              '
'=========================================================='
'Daniel PC (Daniel Carrasco Olguin)                        '
'Santiago de Chile                                         '
'=========================================================='
Public Declare Function GetDiskFreeSpaceEx Lib "kernel32" Alias "GetDiskFreeSpaceExA" (ByVal lpRootPathName As String, lpFreeBytesAvailableToCaller As LARGE_INTEGER, lpTotalNumberOfBytes As LARGE_INTEGER, lpTotalNumberOfFreeBytes As LARGE_INTEGER) As Long
Public Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal lpVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long) As Long
Public Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceA" (ByVal lpRootPathName As String, lpSectorsPerCluster As Long, lpBytesPerSector As Long, lpNumberOfFreeClusters As Long, lpTotalNumberOfClusters As Long) As Long

Public Type LARGE_INTEGER
    Lowpart As Long
    Highpart As Long
End Type

Public Result As Double

Public Const SIZE_KB As Double = 1024
Public Const SIZE_MB As Double = 1024 * SIZE_KB
Public Const SIZE_GB As Double = 1024 * SIZE_MB
Public Const SIZE_TB As Double = 1024 * SIZE_GB

Public Declare Function GetLogicalDriveStrings Lib "kernel32" Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long

Public Const DRIVE_UNKNOWN = 0
Public Const DRIVE_NOTEXIST = 1
Public Const DRIVE_REMOVABLE = 2
Public Const DRIVE_FIXED = 3
Public Const DRIVE_REMOTE = 4
Public Const DRIVE_RAMDISK = 6
Public Const DRIVE_CDROM = 5

Public sDriveNames As String
Public lBuffer As Long
Public lReturn As Long
Public nLoopCtr As Integer
Public nOffset As Integer
Public sTempStr As String

Public Root As String
Public Volume_Name As String
Public Serial_Number As Long
Public Max_Component_Length As Long
Public File_System_Flags As Long
Public File_System_Name As String
Public Pos As Integer
Public Dbl_Total As Double
Public Dbl_Free As Double

Public lSectorsPerCluster As Long
Public lBytesPerSector As Long
Public lFreeClusters As Long
Public lTotalClusters As Long
Public sDrive As String

Public Function LargeIntegerToDouble(Low_Part As Long, High_Part As Long) As Double

Result = High_Part

If High_Part < 0 Then Result = Result + 2 ^ 32
    Result = Result * 2 ^ 32

    Result = Result + Low_Part
If Low_Part < 0 Then Result = Result + 2 ^ 32

    LargeIntegerToDouble = Result
End Function


Public Function SizeString(ByVal Num_Bytes As Double) As String

If Num_Bytes < SIZE_KB Then
        SizeString = Format$(Num_Bytes) & " bytes"
    ElseIf Num_Bytes < SIZE_MB Then
        SizeString = Format$(Num_Bytes / SIZE_KB, "0.00") & " KB"
    ElseIf Num_Bytes < SIZE_GB Then
        SizeString = Format$(Num_Bytes / SIZE_MB, "0.00") & " MB"
    Else
        SizeString = Format$(Num_Bytes / SIZE_GB, "0.00") & " GB"
    End If
End Function

