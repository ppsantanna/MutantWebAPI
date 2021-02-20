Attribute VB_Name = "BackEnd"
Option Explicit

'armazena a string de conexão com o banco
Global glbConBancoDados As String

'API Function to read information from INI File
Public Declare Function GetPrivateProfileString Lib "kernel32" _
    Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any _
    , ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long _
    , ByVal lpFileName As String) As Long

'API Function to write information to the INI File
Private Declare Function WritePrivateProfileString Lib "kernel32" _
    Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any _
    , ByVal lpString As Any, ByVal lpFileName As String) As Long

'Get the INI Setting from the File
Public Function GetINISetting(ByVal sHeading As String, ByVal sKey As String, sINIFileName) As String
    Const cparmLen = 200
    Dim sReturn As String * cparmLen
    Dim sDefault As String * cparmLen
    Dim lLength As Long
    lLength = GetPrivateProfileString(sHeading, sKey _
            , sDefault, sReturn, cparmLen, sINIFileName)
    GetINISetting = Mid(sReturn, 1, lLength)
End Function

'Save INI Setting in the File
Public Function PutINISetting(ByVal sHeading As String, ByVal sKey As String, ByVal glbConBancoDados As String, sINIFileName) As Boolean
    On Error GoTo HandleError
    Const cparmLen = 50
    Dim sReturn As String * cparmLen
    Dim sDefault As String * cparmLen
    Dim aLength As Long
    aLength = WritePrivateProfileString(sHeading, sKey _
            , glbConBancoDados, sINIFileName)
    PutINISetting = True
    Exit Function
    
HandleError:
    Debug.Print Err.Number & " " & Err.Description
End Function

Public Function LerXML(ByVal ChavePesquisa As String) As String
    
    On Error GoTo erros
    Screen.MousePointer = 11
    
    Dim xhr, method, url, contents, formatcontent, node, node2, nodes
    Dim Texto As String
    Dim doc As MSXML2.DOMDocument40
    Dim sectionNode As IXMLDOMElement
    Dim subElt As IXMLDOMElement
    Dim objNodelist As IXMLDOMNodeList
    Dim objNode As IXMLDOMNode
    Dim objListOfNodes As IXMLDOMNodeList
    
    Texto = ""
    
    Set doc = New DOMDocument40
    Set xhr = CreateObject("MSXML2.XMLHTTP")
    
    method = "GET" 'Escolhe o método HTTP de envio
    url = "http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso/FullCountryInfoAllCountries" 'url da API
    contents = "" 'conteudo
    formatcontent = "application/json" 'Se a API usar outro formato basta alterar aqui
    
    xhr.Open method, url, False
    
    'Necessário pra sua API retornar XML ao invés de JSON
    xhr.SetRequestHeader "Accept", "application/xml"
    
    If method = "POST" Or method = "PUT" Then
        xhr.SetRequestHeader "Content-Type", formatcontent
        xhr.SetRequestHeader "Content-Length", Len(contents)
        xhr.Send contents
    Else
        xhr.Send
    End If
    
    If xhr.Status < 200 Or xhr.Status >= 300 Then
        'Algo falhou, as vezes pode haver uma descrição em `xhr.responseText` ou pode retornar vazio, o `xhr.status` indica o tipo de erro
        MsgBox "Erro HTTP:" & xhr.Status & " - Detalhes: " & xhr.ResponseText
        Call Log("Abrir XML", xhr.Status, xhr.ResponseText)
    Else
        Call Log("Abrir XML", xhr.Status, "XML Aberto com Sucesso!")
        'Faz o parse da String para XML
        Set doc = CreateObject("MSXML2.DOMDocument")
        doc.loadXML (xhr.ResponseText)
    
        'Get a nodelist with all the customerDetail nodes
        Set node = doc.selectNodes("//tCountryInfo")
        'Set node = DOC.documentElement _
                                .selectSingleNode ("//tCountryInfo[sISOCode='AE']")
        
        'Loop through the nodelist and pull the vaules you need
        For Each nodes In node
            If Left(nodes.selectSingleNode("sISOCode").Text, 1) = ChavePesquisa Then
                Texto = Texto & "País --> '" & Replace(nodes.selectSingleNode("sISOCode").Text, "'", " ") & "',"
                Texto = Texto & "'" & Replace(nodes.selectSingleNode("sName").Text, "'", " ") & "',"
                Texto = Texto & "'" & Replace(nodes.selectSingleNode("sCapitalCity").Text, "'", " ") & "',"
                Texto = Texto & nodes.selectSingleNode("sPhoneCode").Text & ","
                Texto = Texto & "'" & Replace(nodes.selectSingleNode("sContinentCode").Text, "'", " ") & "',"
                Texto = Texto & "'" & Replace(nodes.selectSingleNode("sCurrencyISOCode").Text, "'", " ") & "',"
                Texto = Texto & "'" & Replace(nodes.selectSingleNode("sCountryFlag").Text, "'", " ") & "'" & vbCrLf
                Texto = Texto & "Língua(s) --> '" + nodes.selectSingleNode("Languages//tLanguage//sISOCode").Text + "','" + nodes.selectSingleNode("sISOCode").Text + "','" + nodes.selectSingleNode("Languages//tLanguage//sName").Text + "'" & vbCrLf
            End If
        Next nodes
        Set node2 = Nothing
        'Cleanup
        Set node = Nothing
    
    End If
    
    LerXML = Texto
    
    Screen.MousePointer = 0
    

erros:
    Select Case Err
        Case 0
        Case 91
            Call Log("Ler XML", Err, "Língua não informada no XML")
            Resume Next
        Case Else
            Call Log("Abrir XML", Err, Error)
    End Select
End Function

Sub GravarDados(ByVal vTexto As String)
    
    On Error GoTo erros
    Screen.MousePointer = 11
    
    Dim conn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim connString As String
    Dim vSQL As String
    Dim strText, i As Integer
    
    connString = glbConBancoDados

    conn.Open connString
    
    
    strText = Split(vTexto, vbCrLf)
    
    For i = LBound(strText, 1) To UBound(strText, 1) - 1
    
        If Left(strText(i), 3) = "Paí" Then
            vSQL = "insert into tCountryInfo select " & Replace(strText(i), "País --> ", "")
        Else
            vSQL = "insert into tLanguage select " & Replace(strText(i), "Língua(s) --> ", "")
        End If
        conn.Execute vSQL, , adCmdText

    Next
    
    conn.Close
    Screen.MousePointer = 0

erros:
    Select Case Err
        Case 0
            Call Log("Gravar Dados", Err, "Dados Gravados Com Sucesso!")
            MsgBox "Dados Gravados Com Sucesso!", vbExclamation
        Case -2147467259
            Call Log("Gravar Dados", Err, Error)
        Case -2147217873
            Call Log("Abrir Conexão", Err, Error)
            Resume Next
        Case Else
            Call Log("Gravar Dados", Err, Error)
            Resume Next
    End Select

End Sub

' General routine for logging errors '
Sub Log(ProcName$, ErrNum&, ErrorMsg$)
  'On Error GoTo ErrHandler
  Dim nUnit As Integer
  nUnit = FreeFile
  ' This assumes write access to the directory containing the program '
  ' You will need to choose another directory if this is not possible '
  Open App.Path & App.EXEName & ".log" For Append As nUnit
  'Print #nUnit, "Error in " & ProcName
  Print #nUnit, Format$(Now) & " --> " & ProcName$ & " --> " & ErrNum & ", " & ErrorMsg
  'Print #nUnit, "  " & ErrNum & ", " & ErrorMsg
  'Print #nUnit
  Close nUnit
  Exit Sub
End Sub

Sub main()

    On Error GoTo ErrHandler
    
    'Reads a INI File (SETTINGS.INI) which has SECTION (SQLSERVER) and HEADING (SERVER) in It
    glbConBancoDados = GetINISetting("SQLSERVER", "SERVER", App.Path & "\SETTINGS.INI")
    'MsgBox glbConBancoDados
    
    'Change the above setting to this one
    'PutINISetting "SQLSERVER", "SERVER", "MyNewSQLServer", App.Path & "\SETTINGS.INI"
    
    Load frmFrontEnd
    frmFrontEnd.Show

ErrHandler:
      'Call Log("MySub", Err, Error$) ' passes name of current routine '
End Sub
