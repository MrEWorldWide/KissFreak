<%@ Page Language="vb" AutoEventWireup="false" CodeFile="EditGallery.aspx.vb" Inherits="EditGallery" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Design a Gallery</title>
</head>
<body>
	    <script type="text/javascript">
	    	function goTo(Page) {
	    		var e = document.getElementById("SelectionGallery");
	    		var sE = e.options[e.selectedIndex].value;
	    		//alert(sE);
	    		//alert(Page);
	    		location.href = 'http://www.kisstradingcard.com/EditGallery.aspx?Action=Delete&Page=' + Page;
	    	}


        </script>

<asp:Table ID="Table1" runat="server" BorderWidth="1px" BorderStyle="Solid" BorderColor="Black" Width="800px" Height="10px" HorizontalAlign="Center" CellPadding="0" CellSpacing="0">
    <asp:TableRow Width="100%" BackColor="Red">
        <asp:TableCell BorderWidth="1px" Height="1px">
            <p style="text-align:center">
                Kiss Freak Photo Gallery
            </p>
        </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow Width="100%" Height="10" BackColor="#F8F5F1" >
        <asp:TableCell BorderWidth="1px">
			
            <p style="text-align:center">
                Modify the <% Response.Write(Request.QueryString("Page") )%> Gallery
                                           	
				<%
                    Dim c As Integer = 0
                    Dim ConnectionString As String = ""
					Dim SQLCon As SqlConnection = New SqlConnection
					Dim SQLCon2 As SqlConnection = New SqlConnection
                    Dim RSWrite As SqlCommand = New SqlCommand
                    Dim RSRead As SqlCommand = New SqlCommand
                    Dim RSRead2 As SqlCommand = New SqlCommand
    
                    Dim dr As SqlDataReader
                    Dim dr2 As SqlDataReader
    
                    Dim SQLSelect As String = ""
                    Dim SQLInsert As String = ""
                    Dim SQLUpdate As String = ""
                    Dim SQLDelete As String = ""

					Dim ContentPage As String = ""
                    Dim PictureName As String = ""
                    Dim Picturetype As String = ""
              
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
							
					'connect to the database #2
					If SQLCon2.State = False Then
						SQLCon2.ConnectionString = ConnectionString
						Try
							SQLCon2.Open()
						Catch ex As Exception
							Response.Write("Connection failure.")

						End Try

					End If
					
					If Not IsNothing(Request.QueryString("Picture")) Then
						If Request.QueryString("Delete") = "True" Then

							Try
								RSWrite = New SqlCommand("Delete FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("Page") & "' AND FilePath='" & Request.QueryString("Picture") & "' AND IMGIndex='" & Request.QueryString("OldIMGIndex") & "'", SQLCon)
								RSWrite.ExecuteNonQuery()
								Response.Write("<font color=""red""><br>Picture Deleted</font>")
							Catch ex As Exception
								Response.Write("<font color=""red"">Failed to delete the Gallery.</font>" & vbCrLf & ex.ToString)
							End Try
						                        						
						End If
					End If
					
					
					If Request.QueryString("Save") = "True" Then

						Try
							RSWrite = New SqlCommand("Update dbo.GalleryInfo SET Caption='" & Request.QueryString("Caption") & "', IMGIndex='" & Request.QueryString("NewIMGIndex") & "', IMGLinkContentPage='" & Request.QueryString("IMGLinkContentPage") & "' WHERE ContentPage='" & Request.QueryString("Page") & "' AND IMGIndex='" & Request.QueryString("OldIMGIndex") & "'", SQLCon)
							RSWrite.ExecuteNonQuery()
							Response.Write("<font color=""red"">Gallery Updated</font>")
						Catch ex As Exception
							Response.Write("<font color=""red"">Failed to save the Gallery</font>" & vbCrLf & ex.ToString)
						End Try
						                        						
					End If
					
					If Request.QueryString("Action") = "DeleteAll" Then
						If Request.QueryString("DeleteAll") = "True" Then

							Response.Write("<form id=""DeleteAll"" method=""get"" action=""Gallery.aspx"">")
							Response.Write("<p style=""text-align:center;"">")
							Response.Write("<input type=""hidden"" name=""Action"" value=""DeleteAll"">")
							Response.Write("<input type=""hidden"" name=""DeleteAll"" value=""True"">")
							Response.Write("<input type=""hidden"" name=""Page"" value=""" & Request.QueryString("Page") & """>")
							Response.Write("Are you sure you want to delete all the photos in the " & Request.QueryString("Page") & " gallery?<br><input type=""submit"" value=""Yes"">")
							Response.Write("</p>")
							Response.Write("</form>")
						                        						
						End If
						
						Try
							RSWrite = New SqlCommand("DELETE FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("Page") & "'", SQLCon)
							RSWrite.ExecuteNonQuery()
							Response.Write("<font color=""red"">Gallery Updated</font>")
						Catch ex As Exception
							Response.Write("<font color=""red"">Failed to save the Gallery</font>" & vbCrLf & ex.ToString)
						End Try
						                        						
					End If
					Response.Write("<div style=""width:800px; height:650px; overflow:auto;"">")
					Response.Write("<table>")
					
					Response.Write("<tr>")
					
					
					
					RSRead = New SqlCommand("SELECT ContentPage, Caption, FilePath, IMGIndex, IMGLinkContentPage FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("Page") & "' ORDER BY IMGIndex", SQLCon)
					dr = RSRead.ExecuteReader

					c = 0
					If dr.HasRows Then
						Response.Write("<form id=""DeleteAll"" method=""get"" action=""EditGallery.aspx"">")
						Response.Write("<p style=""text-align:center;"">")
						Response.Write("<input type=""hidden"" name=""Action"" value=""DeleteAll"">")
						Response.Write("<input type=""hidden"" name=""Page"" value=""" & Request.QueryString("Page") & """>")
						Response.Write("<input type=""submit"" value=""Delete All Pictures"">")
						Response.Write("</p>")
						Response.Write("</form>")
						Do While dr.Read
							c = c + 1
							Response.Write("<td style=""text-align:Center;border:1px solid black"">")
                                                          
							Response.Write("<a  target=""_blank"" href=""Javascript:window.open('/picture.aspx?Picture=" & dr.Item("FilePath").ToString.Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)).Replace("\", "FSL").Replace("/", "FSL") & "','menubar=0,scrollbars=0,width=700,height=750')"">")
							Response.Write("<img width=""250"" height=""250"" src=""" & dr.Item("FilePath").ToString.Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a>")
							Response.Write("<form id=""DeletePicture"" name=""DeletePicture"" method=""post"" action=""EditGallery.aspx?Delete=True&OldIMGIndex=" & dr.Item("IMGIndex") & "&Page=" & Request.QueryString("Page") & "&Picture=" & dr.Item("FilePath").ToString.Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """>")
							Response.Write("<input style=""text-align:left"" id=""Submit"" type=""submit"" value=""Delete Picture"">")
							Response.Write("</form>")
							Response.Write("<br>")

							
							Response.Write("<p style=""text-align:left;"">")
							
							Response.Write("<form id=""EditGallery" & c & """ name=""EditGallery" & c & """ method=""get"" action=""./EditGallery.aspx"" >")
							Response.Write("<input type=""hidden"" name=""IMGIndex"" value=""True"">")
							Response.Write("<input type=""hidden"" name=""Save"" value=""True"">")
							Response.Write("<input type=""hidden"" name=""Page"" value=""" & Request.QueryString("Page") & """>")
							Response.Write("FilePath: " & dr.Item("FilePath").Replace("##DBL", Chr(34)).Replace("##SNG", Chr(39)) & "<br>")
							Response.Write("Index:<input type=""Text"" size=""3"" name=""NewIMGIndex"" value=""" & dr.Item("IMGIndex") & """><br>")
							Response.Write("Index:<input type=""hidden"" size=""3"" name=""OldIMGIndex"" value=""" & dr.Item("IMGIndex") & """><br>")
                             
							Dim tmpcaption As String = dr.Item("Caption")
							Dim tmppage As String = dr.Item("IMGLinkContentPage")
							Response.Write(" Link picture to page:<select form=""EditGallery" & c & """ name=""IMGLinkContentPage""><br>")
							Response.Write("<option value=""" & dr.Item("IMGLinkContentPage") & """>" & dr.Item("IMGLinkContentPage") & "</option>")
							
							
							RSRead2 = New SqlCommand("SELECT ContentPage FROM dbo.Content ORDER BY ContentPage ASC", SQLCon2)
							dr2 = RSRead2.ExecuteReader
							
							If dr2.HasRows Then
								
								Response.Write("<option>None</option>")
								Do While dr2.Read
									Response.Write("<option  value=""" & dr2.Item("ContentPage") & """>" & dr2.Item("ContentPage") & "</option>")
                                     
								Loop
								Response.Write("</select>")
							End If
                             
							dr2.Close()

							Response.Write("<br> Caption:<br><textarea size=""50"" name=""Caption"">" & tmpcaption & "</textarea><br>")
							Response.Write("<input style=""width: 100px;height:20px;"" align=""center"" id=""Submit"" type=""submit"" value=""Save"" height=""15"" width=""20"" />")
                             
							
							Response.Write("</form>")
							Response.Write("</p>")
							
							
							Response.Write("</td>")
                             
							c = c + 1
						Loop
						
						SQLCon2.Close()
					Else
						Response.Write("<p style=""text-align:center"">")
									   
						Response.Write("<font  color=""red"">There are no pictures in this gallery.</font>")
						Response.Write("</p>")
						
					End If
					
					Response.Write("</tr>")
					
					Response.Write("</table><br>")
					Response.Write("</div>")
					
					
					SQLCon.Close()
                    
                    %>



            </p>
				
        </asp:TableCell>
    </asp:TableRow>

</asp:Table>

</body>
</html>
