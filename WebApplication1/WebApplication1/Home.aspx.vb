Imports System.Data.Sql
Imports System.Data.SqlClient


Public Class HomePage
	Inherits System.Web.UI.Page
	Protected MainMessage As String = ""
	Protected PageTitle As String = ""
	Protected ContentPageStyle As String = ""


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

		RSRead = New SqlCommand("SELECT TopicInfo, PageStyle, PageTitle FROM dbo.Content WHERE ContentPage='" & HttpContext.Current.Request.QueryString("Page") & "'", SQLCon)
		dr = RSRead.ExecuteReader

		If dr.HasRows Then
			Do While dr.Read

				'fix quotes
				Dim newstr As String = dr.Item("TopicInfo")
				newstr = newstr.Replace("##DBL", Chr(34))
				newstr = newstr.Replace("##SNG", Chr(39))
				newstr = newstr.Replace("##CRLF", "<br>")
				MainMessage = newstr & " <br>"
				PageTitle = dr.Item("PageTitle")
				ContentPageStyle = dr.Item("PageStyle")
			Loop

		End If

		dr.Close()
		SQLCon.Close()

	End Sub


End Class