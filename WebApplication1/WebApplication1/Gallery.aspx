<%@ Page Language="vb" AutoEventWireup="false" CodeFile="Gallery.aspx.vb" Inherits="GalleryPage" %>
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
    		location.href = 'http://www.kisstradingcard.com/Gallery.aspx?' + Page + '&SelectGallery=' + sE;
    	}


        </script>

<asp:Table ID="Table1" runat="server" BorderWidth="1px" BorderStyle="Solid" BorderColor="Black" Width="800px" Height="10px" HorizontalAlign="Center" CellPadding="0" CellSpacing="0">
    <asp:TableRow Width="100%" BackColor="LightBlue">
        <asp:TableCell BorderWidth="1px" Height="1px">
            <p style="text-align:center">
                Kiss Freak Photo Gallery
            </p>
        </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow Width="100%" Height="10" BackColor="#F8F5F1" >
        <asp:TableCell BorderWidth="1px">
            <p style="text-align:center">
                Design a gallery for Page:				<% Response.Write(Request.QueryString("Page") & "<br>") %>
                                           	
				<%
                    Dim c As Integer = 0
                    Dim ConnectionString As String = ""
                    Dim SQLCon As SqlConnection = New SqlConnection
                    Dim RSWrite As SqlCommand = New SqlCommand
                    Dim RSRead As SqlCommand = New SqlCommand
                    Dim RSRead2 As SqlCommand = New SqlCommand
    
                    Dim dr As SqlDataReader
                    Dim dr2 As SqlDataReader
    
                    Dim SQLSelect As String = ""
                    Dim SQLInsert As String = ""
                    Dim SQLUpdate As String = ""
					Dim SQLDelete As String = ""
					
					Dim WebHostLink As String = "D:\Hosting\11812707\html\pics\"
					
                    Dim ContentPage As String = ""
                    Dim PictureName As String = ""
                    Dim Picturetype As String = ""
					Dim newstr As String = ""
					Dim DirArr() As String = System.IO.Directory.GetFiles(WebHostLink & "\" & Request.QueryString("SelectGallery"))
					
					'get list of optional content pages to link to
					ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;MultipleActiveResultSets=True;"
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
									
					
					If Request.QueryString("Save") = "True" Then
						'Response.Write("--->" & Request.QueryString("Page"))
						'Response.Write("--->" & Request.QueryString("Save"))
						'Response.Write("--->" & Request.QueryString("IMGIndex"))
						'Response.Write("--->" & Request.QueryString("Caption"))
						'Response.Write("--->" & Request.QueryString("IMGLinkContentPage"))
						'Response.Write("--->" & Request.QueryString("FilePath"))												
						'Try
						'	RSRead = New SqlCommand("SELECT IMGIndex FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("Page") & "'", SQLCon)
						'	dr = RSRead.ExecuteReader
						'	Dim IndexOffset As listititem
						'	If dr.HasRows Then
						'		Do While dr.Read
						'			IndexOffset(c) = dr.Item("IMGIndex")
						'		Loop
						'	End If
						'	dr.Close()

						'Catch ex As Exception
						'	Response.Write("<font color=""red"">Failed to calculate index buffer.</font>" & vbCrLf & ex.ToString)
						'End Try
						
						Try
							'fix quotes
							newstr = Request.Form("FilePath")

							newstr = newstr.Replace(Chr(34), "##DBL")
							newstr = newstr.Replace(Chr(39), "##SNG")
							
							RSWrite = New SqlCommand("INSERT INTO dbo.GalleryInfo(ContentPage, Caption, IMGIndex, DateAdded, IMGLinkContentPage, FilePath) VALUES('" & Request.QueryString("Page") & "','" & Request.QueryString("Caption") & "','" & Request.QueryString("IMGIndex") & "','" & Now & "','" & Request.QueryString("IMGLinkContentPage") & "','" & "\pics" & newstr & "')", SQLCon)
							RSWrite.ExecuteNonQuery()
							Response.Write("<font color=""red"">Gallery Updated</font>")
						Catch ex As Exception
							Response.Write("<font color=""red"">Failed to save the Gallery</font>" & vbCrLf & ex.ToString)
						End Try
						                        						                        
					End If

					Dim errmsg As String = ""
					
					If Request.QueryString("Action") Like "SaveAll" Then
						
						Do Until c = DirArr.Length
                             
							If Right(DirArr(c).ToString, 9) <> "Thumbs.db" Then
								Try
									'fix quotes
									newstr = Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink))

									newstr = newstr.Replace(Chr(34), "##DBL")
									newstr = newstr.Replace(Chr(39), "##SNG")
									
									RSWrite = New SqlCommand("INSERT INTO dbo.GalleryInfo(ContentPage, Caption, IMGIndex, DateAdded, IMGLinkContentPage, FilePath) VALUES('" & Request.QueryString("Page") & "',' ', '" & c & "','" & Now & "','None','" & "\pics" & newstr & "')", SQLCon)
									RSWrite.ExecuteNonQuery()
								
								Catch ex As Exception
									errmsg += Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & " Was not saved." & ex.ToString & "<br>"
								End Try
							End If
                         
							c = c + 1
						Loop
						If Len(errmsg) = 0 Then
							Response.Write("<font color=""red"">All pictures saved!</font>")
						Else
							Response.Write("<font color=""red"">All pictures saved except: <br>")
							Response.Write(errmsg & "</font>")
						End If
					End If
					
					
					WebHostLink = "D:\Hosting\11812707\html\pics\"
					DirArr = System.IO.Directory.GetDirectories(WebHostLink)

					c = 0
					
					Response.Write("<p style=""text-align:center"">")
					Response.Write("Picture Galleries:<select id=""SelectionGallery"">") 'form=""LoadGallery"">")

					
					Do Until c = DirArr.Length

						Response.Write("<option id=""Selection"" name=""Selection"" value=""" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & """>" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & "</option>")

						c = c + 1
					Loop
					Response.Write("</select>")
					Response.Write("<button type=""button"" onclick=""goTo('Page=" & Request.QueryString("Page") & "');"">Load</button>")
					'Response.Write("<input type=""submit"" value=""Load"">")
					Response.Write("</p>")
					'Response.Write("</form>")
					
					SQLCon.Close()
                    
                    %>



            </p>
        </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow Width="100%"  BackColor="#F8F5F1" >
        <asp:TableCell BorderWidth="1px">
            <div style="width:800px; height:650px; overflow:auto;">
            <p style="text-align:center">
                Loaded Gallery: <% If Not isnothing(Request.QueryString("SelectGallery")) Then
                                        Response.Write(Request.QueryString("SelectGallery"))
                                    End If
                                    
                                    %>
                 <%
                     Dim c As Integer = 0
                     Dim ConnectionString As String = ""
                     Dim SQLCon As SqlConnection = New SqlConnection
                     Dim RSWrite As SqlCommand = New SqlCommand
                     Dim RSRead As SqlCommand = New SqlCommand
                     Dim RSRead2 As SqlCommand = New SqlCommand
    
                     Dim dr As SqlDataReader
                     Dim dr2 As SqlDataReader
    
                     Dim SQLSelect As String = ""
                     Dim SQLInsert As String = ""
                     Dim SQLUpdate As String = ""
                     Dim SQLDelete As String = ""
                     Dim WebHostLink As String = "D:\Hosting\11812707\html\pics"
                     

                     c = 0

                     If IsNothing(Request.QueryString("SelectGallery")) = False Then
                 		 'save all


                 		 
                 		 Response.Write("<form id=""SaveAll"" method=""get"" action=""Gallery.aspx"">")
                 		 Response.Write("<p style=""text-align:center;"">")
                 		 Response.Write("<input type=""hidden"" name=""Action"" value=""SaveAll"">")
                 		 Response.Write("<input type=""hidden"" name=""Page"" value=""" & Request.QueryString("Page") & """>")
                 		 Response.Write("<input type=""hidden"" name=""SelectGallery"" value=""" & Request.QueryString("SelectGallery") & """>")
                 		 Response.Write("<input type=""submit"" value=""Save All Pictures"">")
                 		 Response.Write("</p>")
                 		 Response.Write("</form>")
                 		 
                 		 'Response.Write("<Br><button type=""button"" onclick=""javascript:window.location.href='Gallery.aspx?Page=" & Request.QueryString("Page") & "&Action=SaveAll&SelectGallery=" & Request.QueryString("SelectGallery") & "'"">Save All Pictures</button>")

				
                 		 
                 		 
						Dim DirArr() As String = System.IO.Directory.GetFiles(WebHostLink & "\" & Request.QueryString("SelectGallery"))
                         
                         Response.Write("<table>")
                         Response.Write("<tr>")
                         'Response.Write(dirarr(c))
                        
                         Do Until c = DirArr.Length
                 			 If Right(DirArr(c).ToString, 9) <> "Thumbs.db" Then
                 				 Response.Write("<td style=""text-align:Center;border:1px solid black"">")

                 				 Response.Write("<a  target=""_blank"" " & c & """ href=""Javascript:window.open('/picture.aspx?Picture=" & ("\pics\" & Request.QueryString("SelectGallery") & "\" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink) - Len(Request.QueryString("SelectGallery")) - 2)).ToString.Replace("\", "FSL").Replace("/", "FSL") & "','menubar=0,scrollbars=0,width=700,height=750')"">")
                 				 Response.Write("<img width=""250"" height=""250"" src=""pics" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & """></a><br>")
                                            			 
                 				 'Response.Write("<form id=""SaveGallery" & c & """ name=""SaveGallery" & c & """ method=""post"" action=""Gallery.aspx?Save=True&Action=Select&Page=" & Request.QueryString("Page") & "&SelectGallery=" & Request.QueryString("SelectGallery") & """ >")
                 				 Response.Write("<form id=""SaveGallery" & c & """ name=""SaveGallery" & c & """ method=""get"" action=""./Gallery.aspx"" >")
                 				 Response.Write("<p style=""text-align:left;"">")
                 				 'Response.Write("<input type=""hidden"" id=""c"" value=""" & c & """>")
                 				 Response.Write("<input type=""hidden"" name=""Action"" value=""Select"">")
                 				 Response.Write("<input type=""hidden"" name=""Save"" value=""True"">")
                 				 Response.Write("<input type=""hidden"" name=""Page"" value=""" & Request.QueryString("Page") & """>")
                 				 Response.Write("<input type=""hidden"" name=""SelectGallery"" value=""" & Request.QueryString("SelectGallery") & """>")
                 				 Response.Write(" FileName: <input type=""hidden"" name=""FileName"" value=""" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink) - Len(Request.QueryString("SelectGallery")) - 2) & """ >     <br> " & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink) - Len(Request.QueryString("SelectGallery")) - 2) & "<br>")
                 				 Response.Write(" FilePath: <input type=""hidden"" name=""FilePath"" value=""" & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & """ >     <br> " & Right(DirArr(c).ToString, Len(DirArr(c).ToString) - Len(WebHostLink)) & "<br>")
                 				 Response.Write(" Index:<input type=""Text"" size=""3"" name=""IMGIndex"" value=""" & c & """><br>")
                             
                 				 'get list of optional content pages to link to
                 				 ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;MultipleActiveResultSets=True;"
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
                             
                 				 RSRead = New SqlCommand("SELECT ContentPage FROM dbo.Content ORDER BY ContentPage ASC", SQLCon)
                 				 dr = RSRead.ExecuteReader
                             
                 				 If dr.HasRows Then
                 					 Response.Write(" Link picture to page:<select form=""SaveGallery" & c & """ name=""IMGLinkContentPage""><br>")
                 					 Response.Write("<option>None</option>")
                 					 Do While dr.Read
                 						 Response.Write("<option value=""" & dr.Item("ContentPage") & """>" & dr.Item("ContentPage") & "</option>")
                                     
                 					 Loop
                 					 Response.Write("</select>")
                 				 End If
                             
                 				 dr.Close()
                 				 SQLCon.Close()

                 				 Response.Write("<br> Caption:<br><textarea size=""50"" name=""Caption""></textarea><br>")
                 				 Response.Write("<input id=""Submit"" type=""submit"" value=""Save"" />")
                             
                 				 Response.Write("</p>")
                 				 Response.Write("</form>")

                 				 Response.Write("</td>")
                             
                 				 
                 			 End If
                 			 c = c + 1
                         Loop
                         Response.Write("</tr>")
                         Response.Write("</table><br>")
                         
                     End If
                     
                 	 
                 	 
                 	 
                 	 %>

            </p>
                </div>
			<%

                    

				 %>
        </asp:TableCell>
    </asp:TableRow>


</asp:Table>

</body>
</html>
