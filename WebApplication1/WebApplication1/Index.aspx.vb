Imports System.Data.Sql
Imports System.Data.SqlClient
Imports System.Data.OleDb

Public Class IndexPage
    Inherits System.Web.UI.Page
    Protected ThemeMusic As String = ""
    Protected SplashImage As String = ""
    Protected counter As Long
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ConnectionString As String
        Dim SQLCon As SqlConnection
        Dim RSWrite As SqlCommand = New SqlCommand
        Dim RSRead As SqlCommand = New SqlCommand

        'Dim SQLCon As OleDbConnection
        'Dim RSWrite As OleDbCommand = New OleDbCommand
        'Dim RSRead As OleDbCommand = New OleDbCommand

        Dim dr As SqlDataReader
        'Dim dr As OleDbDataReader

        Dim SQLSelect As String = ""
        Dim SQLInsert As String = ""
        Dim SQLUpdate As String = ""
        Dim SQLDelete As String = ""



        'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
        ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;"
        SQLCon = New SqlConnection(ConnectionString)

        'ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\inetpub\wwwroot\KissFreak\Kiss Freak WebSite\WebApplication1\WebApplication1\KissFreak.accdb;Persist Security Info=False;"
        'SQLCon = New OleDbConnection(ConnectionString)

        If SQLCon.State = False Then
            SQLCon.ConnectionString = ConnectionString
            Try
                SQLCon.Open()
            Catch ex As Exception
                Response.Write("Connection failure.")

            End Try

        End If

        RSRead = New SqlCommand("SELECT FileName FROM dbo.Songs WHERE ThemeSong=1", SQLCon)
        'RSRead = New OleDbCommand("SELECT FileName FROM dbo_Songs WHERE ThemeSong=1", SQLCon)

        dr = RSRead.ExecuteReader

        If dr.HasRows Then

            dr.Read()
            ThemeMusic = dr.Item("FileName")

        End If
        dr.Close()

        RSRead = New SqlCommand("SELECT FileName FROM dbo.Pictures WHERE Splash=1", SQLCon)
        'RSRead = New OleDbCommand("SELECT FileName FROM dbo_Pictures WHERE Splash=1", SQLCon)
        dr = RSRead.ExecuteReader

        If dr.HasRows Then

            dr.Read()
            SplashImage = dr.Item("FileName")

            dr.Close()

        End If

        'has the visitor been here before?
        RSRead = New SqlCommand("SELECT IP FROM dbo.Visitors WHERE IP='" & Request.ServerVariables("REMOTE_ADDR") & "' AND ContentPage='Index'", SQLCon)
        dr = RSRead.ExecuteReader
        If dr.HasRows Then
            dr.Close()
        Else
            dr.Close()
            RSWrite = New SqlCommand("INSERT INTO dbo.Visitors(IP, VisitDate, ContentPage) VALUES('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Now & "', 'Index')", SQLCon)
            RSWrite.ExecuteNonQuery()
        End If

        dr.Close()

        'load visitor count
        RSRead = New SqlCommand("SELECT COUNT(IP) as TotalVisitors FROM dbo.Visitors WHERE ContentPage='Index'", SQLCon)
        dr = RSRead.ExecuteReader
        counter = 0

        If dr.HasRows Then
            Do While dr.Read
                counter = dr.Item("TotalVisitors")
            Loop

        End If
        Format(counter, "000000")
        dr.Close()


        SQLCon.Close()


    End Sub
End Class
