<%@ Page Language="vb" AutoEventWireup="false" CodeFile="dataTest.aspx.vb" Inherits="dataTest" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
		<%
			Dim ConnectionString As String = ""
			Dim SQLCon As SqlConnection = New SqlConnection
			Dim RSWrite As SqlCommand = New SqlCommand
			Dim RSRead As SqlCommand = New SqlCommand
			Dim RSRead2 As SqlCommand = New SqlCommand
			Dim ContentBlock As String = ""
			Dim c As Integer = 0
    
			Dim dr As SqlDataReader

			Dim SQLSelect As String = ""
			Dim SQLInsert As String = ""
			Dim SQLUpdate As String = ""
			Dim SQLDelete As String = ""
			
			'change all schema first
			'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
			ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;"
			SQLCon = New SqlConnection(ConnectionString)

			'connect to the database
			If SQLCon.State = False Then
				SQLCon.ConnectionString = ConnectionString
				Try
					SQLCon.Open()
				Catch ex As Exception
					Response.Write("Connection failure.")

				End Try

			End If
			
			RSRead = New SqlCommand("SELECT ContentPage, PageTitle, ParentPage, PageStyle, MenuLink,  TopicInfo FROM dbo.Content", SQLCon)
			dr = RSRead.ExecuteReader
			Response.Write("<table width=""100%"">")
			Try
				If dr.HasRows Then
					Do While dr.Read
						Response.Write("<tr>")
					
						For c = 0 To 5
							Response.Write("<td><p style=""text-align:top"">")
							Response.Write(dr.Item(c).ToString)
							Response.Write("</p></td>")
						Next c
					
					
			c = 0
			Response.Write("<br>")
					
			Response.Write("</tr>")
				Loop
				End If
			Catch ex As Exception
				Response.Write(ex.ToString)
			End Try
			
			Response.Write("<br>")
			dr.Close()
			SQLCon.Close()
			
        
			
			%>
    </div>
    </form>
</body>
</html>
