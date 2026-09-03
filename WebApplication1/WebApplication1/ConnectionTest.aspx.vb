Imports System.Data.Sql
Imports System.Data.SqlClient
Imports System
Imports System.IO

Public Class ConnectionTest
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim ConnectionString As String = ""
        Dim SQLCon As SqlConnection = New SqlConnection
        Dim RSWrite As SqlCommand = New SqlCommand
        Dim RSRead As SqlCommand = New SqlCommand

        Dim SQLSelect As String = ""
        Dim SQLInsert As String = ""
        Dim SQLUpdate As String = ""
        Dim SQLDelete As String = ""
        Dim dr As SqlDataReader

        'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
        ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;"
        SQLCon = New SqlConnection(ConnectionString)

        'connect to database
        If SQLCon.State = False Then
            SQLCon.ConnectionString = ConnectionString
            Try
                SQLCon.Open()

            Catch ex As Exception
                Response.Write("Connection failure.")

            End Try

        End If

    End Sub


    Public Shared Function test()
        ' Make a reference to a directory.
        Dim di As New DirectoryInfo("\")
        ' Get a reference to each file in that directory.
        Dim fiArr As FileInfo() = di.GetFiles()
        ' Display the names of the files.
        Dim fri As FileInfo
        For Each fri In fiArr
            Console.WriteLine(fri.Name)
        Next fri
        Return 0
    End Function 'Main

End Class