VERSION 5.00
Begin VB.Form frmFrontEnd 
   BackColor       =   &H80000012&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   6990
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   10350
   Icon            =   "FrontEnd.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6990
   ScaleWidth      =   10350
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdBaixarDados 
      Caption         =   "Baixar Dados"
      Height          =   495
      Left            =   2160
      TabIndex        =   2
      Top             =   6240
      Width           =   2175
   End
   Begin VB.CommandButton cmdSalvarDados 
      Caption         =   "Salvar Dados"
      Enabled         =   0   'False
      Height          =   495
      Left            =   8040
      TabIndex        =   1
      Top             =   6240
      Width           =   2175
   End
   Begin VB.TextBox txtDados 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6015
      Left            =   2160
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   120
      Width           =   8055
   End
   Begin VB.Image Image1 
      Height          =   2000
      Left            =   120
      Picture         =   "FrontEnd.frx":20B6A
      Stretch         =   -1  'True
      Top             =   120
      Width           =   2000
   End
End
Attribute VB_Name = "frmFrontEnd"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
    Option Explicit
    
    Private Req As WinHttp.WinHttpRequest
    Private xmlDoc As MSXML2.DOMDocument40

Private Sub cmdBaixarDados_Click()
    
    Screen.MousePointer = 11
    
    txtDados.Text = LerXML("A")
    cmdSalvarDados.Enabled = True
    
    Screen.MousePointer = 0
End Sub

Private Sub cmdSalvarDados_Click()
   
    On Error GoTo erros
    Screen.MousePointer = 11
   
    Dim Texto As String
    
    Texto = txtDados.Text
    
    GravarDados (Texto)
    
    Screen.MousePointer = 0
    
erros:
    Select Case Err
        Case 0
            
        Case Else
            Resume Next
    End Select
End Sub

Private Sub Form_Load()
    
    Screen.MousePointer = 11
    
    Me.Caption = App.Title
    Set Req = New WinHttp.WinHttpRequest
    
    Screen.MousePointer = 0
End Sub
