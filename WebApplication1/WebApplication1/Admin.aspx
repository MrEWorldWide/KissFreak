<%@ Page Title="" Language="vb" validateRequest="false"  AutoEventWireup="false" MasterPageFile="./Admin.Master" CodeFile="Admin.aspx.vb" Inherits="AdminPage" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.IO" %>


<asp:Content ID="Content3" ContentPlaceHolderID="body" Runat="Server"  >
   
<p style="text-align:center">
<asp:Table ID="Table2" runat="server"  HorizontalAlign="Center" style="border:1px solid black;text-align:Center" CellPadding="5" Width="850" BackColor="LightBlue">
<asp:TableRow>
<asp:TableCell>Kiss Freak Admin Panel</asp:TableCell>
</asp:TableRow> 
</asp:Table>
</p>
<asp:Table ID="Table1" runat="server" HorizontalAlign="Center">
<asp:TableRow>
<asp:TableCell >
  <script>
  	function PageStyleCheckBoxes(RadioID) {

  		var RadioField = document.forms['Contentfrm'];

  		for (var i = 0; i < RadioField.length; i++) {
  			if (RadioField[i].type == 'radio' && i != RadioID - 1) {
  				// alert(radioid & "<br>" & RadioField[i].checked);
  				RadioField[i].checked = false;
  			}
  		}

  	}


  </script>
<%
    Dim c As Integer = 0
    Dim ConnectionString As String = ""
    Dim SQLCon As SqlConnection = New SqlConnection
    Dim RSWrite As SqlCommand = New SqlCommand
    Dim RSRead As SqlCommand = New SqlCommand
    Dim RSRead2 As SqlCommand = New SqlCommand
	Dim sqlcon2 As SqlConnection = New SqlConnection
    Dim dr As SqlDataReader
    Dim dr2 As SqlDataReader
    
    Dim SQLSelect As String = ""
    Dim SQLInsert As String = ""
    Dim SQLUpdate As String = ""
    Dim SQLDelete As String = ""
    
    
    'change all schema first
    'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
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
    
    
    'if a login cookie doesn't exist, begin the login procedure
    If IsNothing(Request.Cookies("Login")) Then
        'is the form empty?
        If Not IsNothing(Request.Form("UserName")) And Not IsNothing(Request.Form("PassWord")) Then

            RSRead = New SqlCommand("SELECT UserName, Password FROM dbo.Admin WHERE UserName='" & Request.Form("UserName") & "' AND PassWord='" & Request.Form("PassWord") & "'", SQLCon)


            dr = RSRead.ExecuteReader

            If dr.HasRows Then

                Dim UserCookie As New HttpCookie("Login")
                UserCookie.Value = "KissFreak"
                Response.Write(UserCookie.Value)
                UserCookie.Expires = DateAdd(DateInterval.Day, +1, Today())
                Response.Cookies.Add(UserCookie)
                Response.Redirect(".\Admin.aspx")
            Else
                'return with failure if login info does not match database
                Response.Write("<center><font color=""red"">Invalid UserName or Password.</font></center>")
            End If
            dr.Close()
        End If
        Response.Write("</form><form id=""Loginfrm"" method=""post"" action=""./Admin.aspx"" style=""text-align:Right"" >")
        Response.Write("UserName: <input id=""UserName"" name=""UserName"" type=""text"" size=""10"" autocomplete=""off""  /><br />")
        Response.Write(" Password: <input id=""Password"" name=""PassWord"" type=""password"" size=""10""/><br />")
        Response.Write("<input id=""Submit"" type=""submit"" value=""Log In"" />")
		Response.Write("</form>")
		
    End If
     
    'last stop to prevent admin panel from displaying
    If IsNothing(Request.Cookies("Login")) = True Then
        Exit Sub

    End If
    
    'check cookie value
    If Request.Cookies("Login").Value = "KissFreak" Then
        Response.Write("<table>")
        Response.Write("<tr>")
        
        'table column titles
        Response.Write("<td width=""180"" style=""text-align:Center;border:1px solid black"">Menu</td>")
        Response.Write("<td width=""600"" style=""text-align:Center;border:1px solid black"">Info</td>")
        Response.Write("</tr>")
        
        'menu links cells, these will trigger different page displays
        Response.Write("<tr>")
        Response.Write("<td style=""text-align:Center"" valign=""top"" >")
        Response.Write("<a href=""admin.aspx?Page=Content&Action=View&ViewPage=Main"">Content</a><br>")
        Response.Write("<a href=""admin.aspx?Page=Pictures"">Pictures</a><br>")
        Response.Write("<a href=""admin.aspx?Page=Music"">Music</a><br>")
        Response.Write("<br><br><a href=""admin.aspx?Page=Logout"">Log Out</a><br>")
        Response.Write("</td>")

		Response.Write("<td valign=""top"">")
        
		'page contents
		Select Case Request.QueryString("Page")
                 
			Case "Logout"

				Dim UserCookie As New HttpCookie("Login")
				UserCookie.Value = "KissFreak"
				Response.Write(UserCookie.Value)
				UserCookie.Expires = DateAdd(DateInterval.Day, -1, Today())
				Response.Cookies.Add(UserCookie)
				Response.Redirect(".\Admin.aspx")

				'control the information displayed on each page
			Case "Content"


                
				'save the already existing content page
				If Request.QueryString("Action") = "Save" Then
                    
					Dim tmpstr As String = Request.Form("ContentPage")
                    
					If Len(Request.Form("PageTitle")) = 0 Then
						Response.Write("----->" & Request.Form("PageTitle"))
						Response.Write("<font color=""red"">Enter a Page Title.<br></font>")
					Else
                        
						Try
							
							Dim tmpstyle As Object = Nothing
							If Request.Form("PageStyle1") = "Left" Then
								tmpstyle = Request.Form("PageStyle1")
							End If
							If Request.Form("PageStyle2") = "Right" Then
								tmpstyle = Request.Form("PageStyle2")
							End If
							If Request.Form("PageStyle3") = "Top" Then
								tmpstyle = Request.Form("PageStyle3")
							End If
							If Request.Form("PageStyle4") = "Tiles" Then
								tmpstyle = Request.Form("PageStyle4")
							End If
							If Request.Form("PageStyle5") = "Staggered" Then
								tmpstyle = Request.Form("PageStyle5")
							End If
                        
							If Len(tmpstyle) = 0 Then tmpstyle = Request.Form("CurrentStyle")
                        
							'fix quotes
							Dim newstr As String = Request.Form("TopicInfo")

							newstr = newstr.Replace(Chr(34), "##DBL")
							newstr = newstr.Replace(Chr(39), "##SNG")
							newstr = newstr.Replace(vbCrLf, "##CRLF")
							'first is main page check
							If IsNothing(Request.Form("ParentPage")) Then
								
								RSWrite = New SqlCommand("UPDATE dbo.Content SET PageTitle='" & Request.Form("PageTitle") & "', TopicInfo='" & newstr & "', PageStyle='" & tmpstyle & "', ModifiedDate='" & Today & "', MenuName='" & Request.Form("MenuName") & "', PayPal='" & IIf(Request.Form("PayPal") = "", 1, 0) & "', PayPalName='" & Request.Form("PayPalName") & "', PayPalEmail='" & Request.Form("PayPalEmail") & "', PayPalPrice='" & Request.Form("PayPalPrice") & "', TaxRate='" & Request.Form("TaxRate") & "', PayPalShipping='" & Request.Form("PayPalShipping") & "' WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
							Else
								RSWrite = New SqlCommand("UPDATE dbo.Content SET PageTitle='" & Request.Form("PageTitle") & "', TopicInfo='" & newstr & "', PageStyle='" & tmpstyle & "', ModifiedDate='" & Today & "', ParentPage='" & Request.Form("ParentPage") & "', MenuName='" & Request.Form("MenuName") & "', PayPal='" & IIf(Request.Form("PayPal") = "on", 1, 0) & "', PayPalName='" & Request.Form("PayPalName") & "', PayPalEmail='" & Request.Form("PayPalEmail") & "', PayPalPrice='" & Request.Form("PayPalPrice") & "', TaxRate='" & Request.Form("TaxRate") & "', PayPalShipping='" & Request.Form("PayPalShipping") & "' WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
							End If
							RSWrite.ExecuteNonQuery()
							Response.Write("<font color=""red"">Content has been saved.</font><br>")
							
						Catch ex As Exception
							Response.Write("<font color=""red"">Failed to save the update." & ex.ToString & "</font>")
						End Try
					End If
				End If
                        
				'check if child pages exists, then delete the page.
				If Request.QueryString("Action") = "Delete" And IsNothing(Request.QueryString("Delete")) Then
					RSRead = New SqlCommand("SELECT ContentPage FROM dbo.Content WHERE ParentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
					dr = RSRead.ExecuteReader
					If dr.HasRows Then
						Response.Write("<table width=""600"" style=""border:1px solid black"">")
						Response.Write("<td>")
						Response.Write("<font color=""red"">There are existing sub pages linked to this page. Before you can delete this page, you must delete all these pages:<br></font><br>")
						Response.Write("</td>")
						Response.Write("</tr>")
						While dr.Read

							Response.Write("<tr>")
							Response.Write("<td width=""200"">")
                                    
							Response.Write("<a href=""admin.aspx?Page=Content&Action=View&ViewPage=" & dr.Item("ContentPage") & """>" & dr.Item("ContentPage") & "</a>")
							Response.Write("</td>")
							Response.Write("</form>")
                                    
							Response.Write("<form id=""DeletePage"" method=""post"" action=""admin.aspx?Page=Content&Action=Delete&ViewPage=" & dr.Item("ContentPage") & """>")
							Response.Write("<td width=""150"">")
							Response.Write("<input id=""Delete"" name=" & dr.Item("ContentPage") & " type=""submit"" Value=""Delete"" />")
							Response.Write("</form>")
                                    
							Response.Write("</td>")
							Response.Write("</tr>")
                             
						End While
						Response.Write("</table>")
					Else
						Response.Write("<table>")
						Response.Write("<tr>")
						Response.Write("<td>")
						Response.Write("</form>Are you sure you want to delete the  " & Request.QueryString("ViewPage") & " page?")
						Response.Write("<form id=""DeletePage"" method=""post"" action=""admin.aspx?Page=Content&Action=Delete&Delete=True&ViewPage=" & Request.QueryString("ViewPage") & """> ")
						Response.Write("<input id=""Save"" name=""SaveBut"" type=""submit"" Value=""Delete"" />")
						Response.Write("</form>")
						Response.Write("<form id=""Cancel"" method=""post"" action=""javascript:history.back()""> ")
						Response.Write("<input id=""Cancel"" name=""SaveBut"" type=""submit"" Value=""Cancel"" />")
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("</tr>")
						Response.Write("</table>")
					End If
					dr.Close()
				End If
                
				'if the delete was confirmed then remove the page if it still exists 
				If Request.QueryString("Action") = "Delete" And Request.QueryString("Delete") = "True" Then
					Dim tmpparent As String = ""

					RSRead = New SqlCommand("SELECT ParentPage FROM dbo.Content WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
					dr = RSRead.ExecuteReader
					If dr.HasRows Then
						Do While dr.Read
							tmpparent = dr.Item("ParentPage")
						Loop
						dr.Close()
					End If
                        
					Try
						RSWrite = New SqlCommand("DELETE FROM dbo.Content WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)

						RSWrite.ExecuteNonQuery()
						Response.Write("<font color=""red"">" & Request.QueryString("ViewPage") & " has been removed.</font><br>")
						Response.Write("<font color=""red"">Click <a href=""admin.aspx?Page=Content&Action=View&ViewPage=" & tmpparent & """>here</a> to return to the parent page.</font><br>")

					Catch ex As Exception
						Response.Write("<font color=""red"">Failed to remove the page." & ex.ToString & "</font>")
					End Try
                    
				End If
				Dim tmpsql As String = ""
				'add a sub page to the parent page       
				If Request.QueryString("Action") = "AddPage" Then
					'if the save button was clicked then add the page if the name already doesn't exist
					If Request.QueryString("Save") = "True" Then
						'check for unique value

						Try
							RSRead = New SqlCommand("SELECT ContentPage FROM dbo.Content WHERE ContentPage='" & Request.Form("ContentPage") & "'", SQLCon)
							dr = RSRead.ExecuteReader()
                            
							If dr.HasRows Then
								dr.Close()
								Response.Write("<font color=""red"">Page name already taken. Choose a new name to continue</font><br>")
                                
							Else
								dr.Close()
                                
								Try

									
									Dim tmpstyle As Object = Nothing
									If Request.Form("PageStyle1") = "Left" Then
										tmpstyle = Request.Form("PageStyle1")
									End If
									If Request.Form("PageStyle2") = "Right" Then
										tmpstyle = Request.Form("PageStyle2")
									End If
									If Request.Form("PageStyle3") = "Top" Then
										tmpstyle = Request.Form("PageStyle3")
									End If
									If Request.Form("PageStyle4") = "Tiles" Then
										tmpstyle = Request.Form("PageStyle4")
									End If
									If Request.Form("PageStyle5") = "Staggered" Then
										tmpstyle = Request.Form("PageStyle5")
									End If
                                    
									'fix quotes
									Dim newstr As String = Request.Form("TopicInfo")
									newstr = newstr.Replace(Chr(34), "##DBL")
									newstr = newstr.Replace(Chr(39), "##SNG")
									newstr = newstr.Replace(vbCrLf, "##CRLF")
                                    
									tmpsql = "INSERT INTO dbo.Content(TopicInfo, ContentPage, ParentPage, PageTitle, CreationDate, ModifiedDate, PageStyle, MenuName, MenuLink, PayPal, PayPalName, PayPalPrice, PayPalShipping, TaxRate"
                                    
									tmpsql = tmpsql & ") VALUES('" & newstr & "','" & Request.Form("PageName") & "', '" & Request.form("ParentPage") & "','" & Request.Form("PageTitle") & "','" & Now & "','" & Now & "', '" & tmpstyle & "','" & Request.Form("MenuName") & "'"
                                    
									If Request.Form("MenuLink") = "on" Then
										tmpsql = tmpsql & ",1"
									Else
										tmpsql = tmpsql & ",0"
									End If
                                    
									tmpsql = tmpsql & ",'" & Request.Form("PayPal") & "','" & Request.Form("PayPalName") & "','" & Request.Form("PayPalPrice") & "','" & Request.Form("PayPalShipping") & "','" & Request.Form("TaxRate") & "'"
									
									tmpsql = tmpsql & ")"

									RSWrite = New SqlCommand(tmpsql, SQLCon)
									RSWrite.ExecuteNonQuery()
									Response.Write("<font color=""red"">" & Request.Form("PageName") & " has been created.</font><br>")
									Response.Write("<font color=""red"">Click <a href=""admin.aspx?Page=Content&Action=View&ViewPage=" & Request.QueryString("ViewPage") & """>here</a> to return to the parent page.</font><br>")
									
								Catch ex As Exception
									Response.Write("<font color=""red"">Failed to save the update." & vbCrLf & tmpsql & vbCrLf & ex.ToString & "</font>")
								End Try
							End If


						Catch ex As Exception
							Response.Write("<font color=""red"">Failed to save the update." & ex.ToString & "</font>")
						End Try
                        
					End If
					'end save if
					
					
					Response.Write("<table>")
					Response.Write("<tr>")
					Response.Write("<td>")
					Response.Write("</form><form id=""AddPage"" name=""AddPage"" method=""post"" action=""admin.aspx?Page=Content&Action=AddPage&Save=True&ViewPage=" & Request.QueryString("ViewPage") & """> ")					
					
					If Request.QueryString("ViewPage") <> "Main" Then
						'connect to the database
						If sqlcon2.State = False Then
							sqlcon2.ConnectionString = ConnectionString
							Try
								sqlcon2.Open()
							Catch ex As Exception
								Response.Write("Connection failure.")

							End Try

						End If

						RSRead2 = New SqlCommand("SELECT ParentPage FROM dbo.Content WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", sqlcon2)
						dr2 = RSRead2.ExecuteReader																	
						
						
						If dr2.HasRows Then
							Response.Write("Parent Page:<select form=""AddPage"" name=""ParentPage"">")
							Response.Write("<option value=""" & Request.QueryString("ViewPage") & """>" & Request.QueryString("ViewPage") & "</option>")
							Do While dr2.Read
								Response.Write("<option value=""" & dr2.Item("ParentPage") & """>" & dr2.Item("ParentPage") & "</option>")
                                     
							Loop
							Response.Write("</select><br>")
						End If
					
						dr2.Close()
						sqlcon2.Close()
					Else
						Response.Write("<input type=""hidden"" name=""ParentPage"" value=""Main"">")
						sqlcon2.Close()
					End If
					
					
						

					Response.Write("Page Name:<br><input type=""text"" name=""PageName""  size=""25"" value=""" & Request.Form("PageName") & """><br>")
					Response.Write("Page Title:<br><input type=""text"" name=""PageTitle""  size=""25"" value=""" & Request.Form("PageTitle") & """><br>")
					Response.Write("Menu Name:<br><input type=""text"" name=""MenuName""  size=""25"" value=""" & Request.Form("MenuName") & """><br>")
					Response.Write("Page Information:<br><textarea id=""TopicInfo"" name=""TopicInfo""  rows=""5"" cols=""70"">" & Request.Form("TopicInfo") & "</textarea><br>")
					Response.Write("<input type=""radio"" id=""PageStyle"" name=""PageStyle1""  rows=""5"" cols=""70"" onclick=""javascript:PageStyleCheckBoxes(2);"" value=""Left"" checked>Pictures Left<br>")
					Response.Write("<input type=""radio"" id=""PageStyle"" name=""PageStyle2""  rows=""5"" cols=""70"" onclick=""javascript:PageStyleCheckBoxes(3);"" value=""Right"">Pictures Right<br>")
					Response.Write("<input type=""radio"" id=""PageStyle"" name=""PageStyle3""  rows=""5"" cols=""70"" onclick=""javascript:PageStyleCheckBoxes(4);"" value=""Top"">Pictures Top<br>")
					Response.Write("<input type=""radio"" id=""PageStyle"" name=""PageStyle4""  rows=""5"" cols=""70"" onclick=""javascript:PageStyleCheckBoxes(5);"" value=""Tiles"">Pictures Tiles<br>")
					Response.Write("<input type=""radio"" id=""PageStyle"" name=""PageStyle5""  rows=""5"" cols=""70"" onclick=""javascript:PageStyleCheckBoxes(6);"" value=""Staggered"">Pictures Staggered<br><br>")

					'only if it is linked to the main page can you make it a main menu link
					If Request.QueryString("ViewPage") = "Main" Then
						Response.Write("<input type=""checkbox"" id=""MenuLink"" name=""MenuLink"">Main Menu Link?<br><br>")
					End If

					Response.Write("<input type=""checkbox"" id=""PayPal"" name=""PayPal"">Enable PayPal<br>")
					Response.Write("PayPal Email: <input type=""text"" size=""20"" name=""PayPalEmail"" value=""kissfreak@paypal.com""><br>")
					Response.Write("PayPal Item Name: <input type=""text"" size=""20"" name=""PayPalName""><br>")
					Response.Write("Price: <input type=""text"" size=""7"" name=""PayPalPrice"" value=""0.00""><br>")
					Response.Write("Tax Rate: <input type=""text"" size=""5"" name=""TaxRate"" value="".87""><br>")
					Response.Write("Shipping Rate: <input type=""text"" size=""5"" name=""PayPalShipping"" value=""5.00""><br><br><br>")
					
					
					RSRead = New SqlCommand("SELECT DISTINCT(ContentPage) FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
					dr = RSRead.ExecuteReader
					
					If dr.HasRows Then
						Do While dr.Read
							Response.Write("<a target=""_blank"" href=""EditGallery.aspx?Action=Edit&Page=" & Request.QueryString("ViewPage") & """>Modify Pictures</a><br>")
						Loop
					End If
					dr.Close()
					SQLCon.Close()
					
					Response.Write("<br><input id=""Save"" name=""SaveBut"" type=""submit"" Value=""Save"" />")
					Response.Write("</form>")
					Response.Write("</td>")
					Response.Write("</tr>")
					Response.Write("</table>")
				End If
                        
				'if saving or viewing
				If Request.QueryString("Action") = "Save" Or Request.QueryString("Action") = "View" Then
					
					RSRead = New SqlCommand("SELECT MenuName, TopicInfo, ContentPage, ParentPage, CreationDate, ModifiedDate, PageTitle, PageStyle, PayPal, PayPalName, PayPalPrice, PayPalEmail, TaxRate, PayPalShipping FROM dbo.Content WHERE ContentPage='" & Request.QueryString("ViewPage") & "' ORDER BY ContentPage", SQLCon)
                   
					'get all content fields for the page viewed
					dr = RSRead.ExecuteReader
					
					Dim tmpparent As String = ""
					
					If dr.HasRows Then
						
						Response.Write("<table>")
						Response.Write("<tr>")
						Response.Write("<td width=""200"">")
						Response.Write("<br><Br><br><br>Sub Pages for: " & Request.QueryString("ViewPage") & "<br>")
						Response.Write("</td>")

						Response.Write("<td style=""text-align:right"" valign=""Tiles""  width=""450"">")
						Response.Write("</form><form ID=""AddPage"" method=""post"" name=""AddPage"" action=""admin.aspx?Page=Content&Action=AddPage&ViewPage=" & Request.QueryString("ViewPage") & """>")
						Response.Write("<input type=""submit"" value=""Add Sub Page"" name=""submit"">")
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("</tr>")
						Response.Write("<tr>")
						Response.Write("</form><form id=""Contentfrm"" method=""post"" action=""admin.aspx?Page=Content&Action=Save&ViewPage=" & Request.QueryString("ViewPage") & """> ")
						
						Do While dr.Read
							tmpparent = dr.Item("ParentPage")
							
						Loop
						
						If Request.QueryString("ViewPage") <> "Main" Then
							
							'connect to the database
							If sqlcon2.State = False Then
								sqlcon2.ConnectionString = ConnectionString
								Try
									sqlcon2.Open()
								Catch ex As Exception
									Response.Write("Connection failure.")

								End Try

							End If

							RSRead2 = New SqlCommand("SELECT ParentPage FROM dbo.Content WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", sqlcon2)
							dr2 = RSRead2.ExecuteReader
							
							If dr2.HasRows Then
								Do While dr2.Read
									Response.Write("Click <a href=""admin.aspx?Page=Content&Action=View&ViewPage=" & dr2.Item("ParentPage") & """>here</a> to return to the parent page.<br>")
								Loop
								
							End If
					
							dr2.Close()
						
							'get list of optional content pages to link to
							ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;MultipleActiveResultSets=True;"
							sqlcon2 = New SqlConnection(ConnectionString)
   
					
						
							'connect to the database
							If sqlcon2.State = False Then
								sqlcon2.ConnectionString = ConnectionString
								Try
									sqlcon2.Open()
								Catch ex As Exception
									Response.Write("Connection failure.")

								End Try

							End If
					
					
							RSRead2 = New SqlCommand("SELECT ContentPage FROM dbo.Content ORDER BY ContentPage", sqlcon2)
							dr2 = RSRead2.ExecuteReader
                             
							If dr2.HasRows Then
								Response.Write("Parent Page:<select form=""Contentfrm"" name=""ParentPage"">")
								Response.Write("<option value=""" & tmpparent & """>" & tmpparent & "</option>")
								Do While dr2.Read
									Response.Write("<option value=""" & dr2.Item("ContentPage") & """>" & dr2.Item("ContentPage") & "</option>")
                                     
								Loop
								Response.Write("</select><br>")
							End If
					
							dr2.Close()
								
					
							sqlcon2.Close()
							
						End If
						
						dr.Close()
						dr = RSRead.ExecuteReader
						While dr.Read
                            
							If Request.QueryString("ViewPage") <> "Main" And Request.QueryString("ViewPage") <> "PayPal" Then
								
								Response.Write("Page Name: ")
								Response.Write("<input type=""text"" id=""ContentPage"" name""ContentPage"" size=""20"" value=""" & dr.Item("ContentPage") & """><br>")
									
                                
							Else
								Response.Write("Page Name: ")
								Response.Write("<input type=""hidden"" id=""ContentPage"" name""ContentPage"" size=""20"" value=""" & dr.Item("ContentPage") & """>" & dr.Item("ContentPage") & "<br>")

							End If
							Response.Write("Page Title: ")
							Response.Write("<input type=""text"" id=""PageTitle"" name=""PageTitle"" size=""20"" value=""" & dr.Item("PageTitle") & """><br>")
                                
							'fix quotes
							Dim newstr As String = dr.Item("TopicInfo")
							newstr = newstr.Replace("##DBL", Chr(34))
							newstr = newstr.Replace("##SNG", Chr(39))
							newstr = newstr.Replace("##CRLF", Environment.NewLine)
							Response.Write("Menu Name:<input type=""text"" name=""MenuName""  size=""25"" value=""" & dr.Item("MenuName") & """><br>")
							Response.Write("Page Information:<br><textarea id=""TopicInfo"" name=""TopicInfo""  rows=""5"" cols=""70"">" & newstr & "</textarea><br>")
							Response.Write("Current Page Style: " & dr.Item("PageStyle") & "<br>")
							Response.Write("<input type=""hidden"" name=""CurrentStyle"" id=""CurrentStyle"" value=""" & dr.Item("PageStyle") & """>")
                          
							
							If Request.QueryString("ViewPage") = "Main" Then
								If dr.Item("PageStyle") = "Left" Then
									Response.Write("<input type=""radio"" id=""PageStyle1"" name=""PageStyle1"" onclick=""javascript:PageStyleCheckBoxes(6);"" value=""Left"" checked>Pictures Left<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle1"" name=""PageStyle1""   onclick=""javascript:PageStyleCheckBoxes(6);"" value=""Left"">Pictures Left<br>")
								End If
                            
								If dr.Item("PageStyle") = "Right" Then
									Response.Write("<input type=""radio"" id=""PageStyle2"" name=""PageStyle2"" onclick=""javascript:PageStyleCheckBoxes(7);"" value=""Right"" checked>Pictures Right<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle2"" name=""PageStyle2""  onclick=""javascript:PageStyleCheckBoxes(7);"" value=""Right"">Pictures Right<br>")
								End If
                            
								If dr.Item("PageStyle") = "Top" Then
									Response.Write("<input type=""radio"" id=""PageStyle3"" name=""PageStyle3""  onclick=""javascript:PageStyleCheckBoxes(8);"" value=""Top"" checked>Pictures Top<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle3"" name=""PageStyle3""  onclick=""javascript:PageStyleCheckBoxes(8);"" value=""Top"">Pictures Top<br>")
								End If
                            
								If dr.Item("PageStyle") = "Tiles" Then
									Response.Write("<input type=""radio"" id=""PageStyle4"" name=""PageStyle4""  onclick=""javascript:PageStyleCheckBoxes(9);"" value=""Tiles"" checked=""checked"">Pictures Tiles<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle4"" name=""PageStyle4""  onclick=""javascript:PageStyleCheckBoxes(9);"" value=""Tiles"">Pictures Tiles<br>")
								End If
                            
								If dr.Item("PageStyle") = "Staggered" Then
									Response.Write("<input type=""radio"" id=""PageStyle5"" name=""PageStyle5""  onclick=""javascript:PageStyleCheckBoxes(10);"" value=""Staggered"" checked>Pictures Staggered<br><br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle5"" name=""PageStyle5""  onclick=""javascript:PageStyleCheckBoxes(10);"" value=""Staggered"">Pictures Staggered<br><br>")
								End If
							
							Else
								If dr.Item("PageStyle") = "Left" Then
									Response.Write("<input type=""radio"" id=""PageStyle1"" name=""PageStyle1"" onclick=""javascript:PageStyleCheckBoxes(7);"" value=""Left"" checked>Pictures Left<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle1"" name=""PageStyle1""   onclick=""javascript:PageStyleCheckBoxes(7);"" value=""Left"">Pictures Left<br>")
								End If
                            
								If dr.Item("PageStyle") = "Right" Then
									Response.Write("<input type=""radio"" id=""PageStyle2"" name=""PageStyle2"" onclick=""javascript:PageStyleCheckBoxes(8);"" value=""Right"" checked>Pictures Right<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle2"" name=""PageStyle2""  onclick=""javascript:PageStyleCheckBoxes(8);"" value=""Right"">Pictures Right<br>")
								End If
                            
								If dr.Item("PageStyle") = "Top" Then
									Response.Write("<input type=""radio"" id=""PageStyle3"" name=""PageStyle3""  onclick=""javascript:PageStyleCheckBoxes(9);"" value=""Top"" checked>Pictures Top<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle3"" name=""PageStyle3""  onclick=""javascript:PageStyleCheckBoxes(9);"" value=""Top"">Pictures Top<br>")
								End If
                            
								If dr.Item("PageStyle") = "Tiles" Then
									Response.Write("<input type=""radio"" id=""PageStyle4"" name=""PageStyle4""  onclick=""javascript:PageStyleCheckBoxes(10);"" value=""Tiles"" checked=""checked"">Pictures Tiles<br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle4"" name=""PageStyle4""  onclick=""javascript:PageStyleCheckBoxes(10);"" value=""Tiles"">Pictures Tiles<br>")
								End If
                            
								If dr.Item("PageStyle") = "Staggered" Then
									Response.Write("<input type=""radio"" id=""PageStyle5"" name=""PageStyle5""  onclick=""javascript:PageStyleCheckBoxes(11);"" value=""Staggered"" checked>Pictures Staggered<br><br>")
								Else
									Response.Write("<input type=""radio"" id=""PageStyle5"" name=""PageStyle5""  onclick=""javascript:PageStyleCheckBoxes(11);"" value=""Staggered"">Pictures Staggered<br><br>")
								End If
							End If
							
							If dr.Item("PayPal") = 1 Then
								Response.Write("<input type=""checkbox"" id=""PayPal"" name=""PayPal"" >Disable PayPal(Paypal is currently enabled)<br>")
							Else
								Response.Write("<input type=""checkbox"" id=""PayPal"" name=""PayPal"">Enable PayPal(Paypal is currently disabled)<br>")
							End If
							
							Response.Write("PayPal Email: <input type=""text"" size=""20"" name=""PayPalEmail"" value=""" & dr.Item("PayPalEmail") & """><br>")
							Response.Write("PayPal Item Name: <input type=""text"" size=""20"" name=""PayPalName"" value=""" & dr.Item("PayPalName") & """><br>")
							Response.Write("Price: <input type=""text"" size=""7"" name=""PayPalPrice"" value=""" & dr.Item("PayPalPrice") & """><br>")
							Response.Write("Tax Rate: <input type=""text"" size=""5"" name=""TaxRate"" value=""" & dr.Item("TaxRate") & """><br>")
							Response.Write("Shipping Rate: <input type=""text"" size=""5"" name=""PayPalShipping"" value=""" & dr.Item("PayPalShipping") & """><br><br><br>")

							
							'Response.Write("<a href=""Javascript:window.open('Gallery.aspx?Action=Select&Page=" & dr.Item("ContentPage") & "','popUpWindow','menubar=0,scrollbars=0,width=700,height=800')"">Modify Pictures</a><br>")
							Response.Write("<a target=""_blank"" href=""./Gallery.aspx?Action=Select&Page=" & dr.Item("ContentPage") & """>Add Pictures</a><br>")
							

							
						End While
						
						dr.Close()
						
						RSRead = New SqlCommand("SELECT ContentPage FROM dbo.GalleryInfo WHERE ContentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
						dr = RSRead.ExecuteReader
					
						If dr.HasRows Then
							Response.Write("<a target=""_blank"" href=""EditGallery.aspx?Action=Edit&Page=" & Request.QueryString("ViewPage") & """>Modify Pictures</a><br>")
						End If
						dr.Close()

						
						
						
						
						
						
                        
						Response.Write("<br><input id=""Save"" name=""SaveBut"" type=""submit"" Value=""Save"" />")
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("</tr>")
						Response.Write("<br>")
						Response.Write("</table>")

					End If
                            
					dr.Close()
                    
					RSRead = New SqlCommand("SELECT MenuLink, ContentPage, ParentPage, CreationDate, ModifiedDate FROM dbo.Content WHERE ParentPage='" & Request.QueryString("ViewPage") & "'", SQLCon)
                    
					'get all content fields
					dr = RSRead.ExecuteReader
  
					If dr.HasRows Then
						Response.Write("<table width=""650"" style=""border:1px solid black"">")
						Response.Write("<td>")
						Response.Write("Page Name<br>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("Main Link? <br>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("Delete Page?<br>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("Date Created<br>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("Date Modified<br>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("Number of Visits<br>")
						Response.Write("</td>")
                        
						Response.Write("</tr>")
						While dr.Read

							Response.Write("<tr>")
							Response.Write("<td width=""200"">")
                                    
							Response.Write("<a href=""admin.aspx?Page=Content&Action=View&ViewPage=" & dr.Item("ContentPage") & """>" & dr.Item("ContentPage") & "</a>")
							Response.Write("</td>")
							Response.Write("</form>")
                                 
							Response.Write("<td width=""150"" style=""text-align:right"">")
							If dr.Item("ContentPage") = "Main" Or dr.Item("ContentPage") = "PayPal" Then
								Response.Write("Master Page")
							ElseIf dr.Item("MenuLink") = 1 Then
								Response.Write("Yes")
							Else
								Response.Write("No")
							End If
							Response.Write("</td>")
                            
							Response.Write("<td width=""150"" style=""text-align:right"">")
							If dr.Item("ContentPage") <> "Main" And dr.Item("ContentPage") <> "PayPal" Then
								Response.Write("<form id=""DeletePage"" method=""post"" action=""admin.aspx?Page=Content&Action=Delete&ViewPage=" & dr.Item("ContentPage") & """>")
								Response.Write("<input id=""Delete"" name=""" & dr.Item("ContentPage") & """ type=""submit"" Value=""Delete"" />")
								Response.Write("</form>")
							End If
                            
							Response.Write("</td>")
                            
							Dim tmpdate As Date = dr.Item("CreationDate")
							Dim tmpstr As String = ""
                            
							'load visitor count
							RSRead2 = New SqlCommand("SELECT COUNT(IP) as TotalVisitors FROM dbo.Visitors WHERE ContentPage='" & dr.Item("ContentPage") & "'", SQLCon)
							dr2 = RSRead2.ExecuteReader

							If dr2.HasRows Then
								Do While dr2.Read
									If IsDBNull(dr2.Item("TotalVisitors")) Then
										tmpstr = 0
									Else
										tmpstr = dr2.Item("TotalVisitors")
									End If
								Loop

							End If
							Format(tmpstr, "000000")
							dr2.Close()
                            
                            
                            
							Response.Write("<td width=""150"" style=""text-align:right"">")
							Response.Write(tmpdate.ToShortDateString)
							Response.Write("</td>")
                            
							tmpdate = dr.Item("ModifiedDate")
							Response.Write("<td width=""150"" style=""text-align:right"">")
							Response.Write(tmpdate.ToShortDateString)
							Response.Write("</td>")
                            
							Response.Write("<td width=""150"" style=""text-align:right"">")
                                                        
							Response.Write(tmpstr)
							Response.Write("</td>")
                            
                            
							Response.Write("</tr>")
                             
						End While
						Response.Write("</table>")
					End If
                    
					dr.Close()
                            
				End If
                        
                        
				'add or delete photos
			Case "Pictures"
                        
				If Request.QueryString("ConfirmDelete") = "True" Then
                            
					Try
						RSWrite = New SqlCommand("DELETE FROM dbo.Songs WHERE FileName='" & Request.QueryString("File") & "'", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("DELETE FROM dbo_Songs WHERE FileName='" & Request.QueryString("File") & "'", SQLCon)
						RSWrite.ExecuteNonQuery()
						Response.Write("<font color=""red"">" & Request.QueryString("File") & " was successfully removed.</font>")

					Catch ex As Exception
						Response.Write("<font color=""red"">Failed to remove " & Request.QueryString("File") & ".</font>")

					End Try
                            
				ElseIf Request.QueryString("Action") = "Delete" Then

					Response.Write("</form>Are you sure you want to delete " & Request.QueryString("File") & "?<br>")
					Response.Write("<form id=""DeletePicture"" name=""DeletePicture"" method=""post"" action="".\admin.aspx?Page=Picture&ConfirmDelete=True&File=" & Request.QueryString("File") & """> ")
					Response.Write("<input id=""Delete"" type=""submit"" Value=""Delete"" />")
					Response.Write("</form>")
					Response.Write("<br>")
					Exit Sub
				ElseIf Request.QueryString("Action") = "Add" Then
					'get all pictures in the web directory
					If Not (IsPostBack) Then
						Try
							Dim fr As System.Net.HttpWebRequest
							Dim targetURI As New Uri("http://www.KissTradingCard.com/Pics")
 
							fr = DirectCast(System.Net.HttpWebRequest.Create(targetURI), System.Net.HttpWebRequest)
							'In the above code Http://www.KissTradingCard.com/pics is used as an example
							'it can be a different domain with a different filename and extension
							If (fr.GetResponse().ContentLength > 0) Then
								Dim str As New System.IO.StreamReader(fr.GetResponse().GetResponseStream())
								Response.Write(str.ReadToEnd())
							End If
 
						Catch ex As System.Net.WebException
							Response.Write("File does not exist." & vbCrLf & ex.ToString)
						End Try
					End If
				ElseIf Request.QueryString("Action") = "Theme" Then
					Try
						RSWrite = New SqlCommand("UPDATE dbo.Pictures SET Splash=0", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("UPDATE dbo_Pictures SET Splash=0", SQLCon)
						RSWrite.ExecuteNonQuery()
                                
						RSWrite = New SqlCommand("UPDATE dbo.Pictures SET Splash=1 WHERE PictureName='" & Request.QueryString("File") & "'", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("UPDATE dbo_Pictures SET Splash=1 WHERE PictureName='" & Request.QueryString("File") & "'", SQLCon)
						RSWrite.ExecuteNonQuery()
						Response.Write("<font color=""red"">" & Request.QueryString("File") & " is now the splash image on the front page.</font>")
					Catch ex As Exception
						Response.Write("Failed to reset the splash image." & ex.ToString)
                                
					End Try
                            
                            
				Else
					'upload image to server
					Response.Write("<a href="".\admin.aspx?Page=Pictures&Action=Add"" > Click to Add a Picture</a> ")

                            
				End If
				RSRead = New SqlCommand("SELECT FileName, PictureName, Splash, Size, UploadDate FROM dbo.Pictures", SQLCon)
				'RSRead = New System.Data.OleDb.OleDbCommand("SELECT FileName, PictureName, Splash, [Size], UploadDate FROM dbo_Pictures", SQLCon)
				dr = RSRead.ExecuteReader
				If dr.HasRows Then
					Response.Write("<table>")
					Response.Write("<tr>")
					Response.Write("<br><td>Picture</td><td>File Size</td><td>Upload Date</td>")
					Response.Write("</tr>")
					Response.Write("<tr>")
					While dr.Read
						Response.Write("<tr>")
						Response.Write("<td width=""200"">")
						Response.Write("<a href="""" onclick=""window.open('picture.aspx?Picture=" & dr.Item("FileName") & "','popUpWindow','menubar=0,scrollbars=0')"">")
						Response.Write(dr.Item("PictureName"))
						Response.Write("</a>")
						Response.Write("</td>")
						Response.Write("<td width=""70""> " & dr.Item("Size") & " kb </td>")
						Response.Write("<td width=""150""> " & dr.Item("UploadDate") & "</td>")
						Response.Write("<td>")
						Response.Write("</form><form id=""Picturefrm"" method=""post"" action=""admin.aspx?Page=Pictures&Action=Theme&File=" & dr.Item("PictureName") & """> ")
						If dr.Item("Splash") = 0 Then
							Response.Write("<input id=""Edit"" name=" & dr.Item("PictureName") & " type=""submit"" Value=""Make Theme"" />")
						ElseIf dr.Item("Splash") = 1 Then
							Response.Write("Current Splash")
						End If
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("<form id=""Picturefrm"" method=""post"" action=""admin.aspx?Page=Pictures&Action=Delete&File=" & dr.Item("FileName") & """> ")
						Response.Write("<input id=""Delete"" name=" & dr.Item("FileName") & " type=""submit"" Value=""Delete"" />")
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("</tr>")
					End While
					Response.Write("</tr>")
					Response.Write("</table>")
                   
                            

				Else
					'return with failure if login info does not match database
					Response.Write("<font color=""red"" style=""color:red"">There are no Pictures.</font>")
				End If
				dr.Close()
                      
				'Add or delete songs
			Case "Music"
                        
				If Request.QueryString("ConfirmDelete") = "True" Then
                            
					Try
						RSWrite = New SqlCommand("DELETE FROM dbo.Songs WHERE FileName='" & Request.QueryString("File") & "'", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("DELETE FROM dbo_Songs WHERE FileName='" & Request.QueryString("File") & "'", SQLCon)
						RSWrite.ExecuteNonQuery()
						Response.Write("<font color=""red"">" & Request.QueryString("File") & " was successfully removed.</font>")

					Catch ex As Exception
						Response.Write("<font color=""red"">Failed to remove " & Request.QueryString("File") & ".</font>")

					End Try
                            
				ElseIf Request.QueryString("Action") = "Delete" Then

					Response.Write("</form>Are you sure you want to delete " & Request.QueryString("File") & "?<br>")
					Response.Write("<form id=""DeleteSong"" name=""DeleteSong"" method=""post"" action="".\admin.aspx?Page=Music&ConfirmDelete=True&File=" & Request.QueryString("File") & """> ")
					Response.Write("<input id=""Delete"" type=""submit"" Value=""Delete"" />")
					Response.Write("</form>")
					Response.Write("<br>")
					Exit Sub
				ElseIf Request.QueryString("Action") = "Add" Then
					Try
                                
						''ftp upload
						'Dim clsRequest As System.Net.FtpWebRequest = _
						'DirectCast(System.Net.WebRequest.Create("ftp://ftp.myserver.com/test.txt"), System.Net.FtpWebRequest)
						'clsRequest.Credentials = New System.Net.NetworkCredential("myusername", "mypassword")
						'clsRequest.Method = System.Net.WebRequestMethods.Ftp.UploadFile
 
						'' read in file...
						'Dim bFile() As Byte = System.IO.File.ReadAllBytes("C:\Temp\test.txt")
 
						'' upload file...
						'Dim clsStream As System.IO.Stream = _
						'    clsRequest.GetRequestStream()
						'clsStream.Write(bFile, 0, bFile.Length)
						'clsStream.Close()
						'clsStream.Dispose()
                                
                                
						'add picture
						System.IO.File.Copy(Request.FilePath & "\" & Request.Files(0).FileName, "Songs\" & Request.Files(0).FileName, False)
						Response.Write("")
						Response.Write(".\Songs\" & Request.Files(0).FileName)
					Catch ex As Exception
						Response.Write(Request.Item("FileName") & "\" & Request.Files(0).FileName & " <font color=""red"" style=""color:red"">Error adding song. " & ex.ToString & "</font>")
                                
                                
					End Try
				ElseIf Request.QueryString("Action") = "Theme" Then
					Try
						RSWrite = New SqlCommand("UPDATE dbo.Songs SET ThemeSong=0", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("UPDATE dbo_Songs SET ThemeSong=0", SQLCon)
						RSWrite.ExecuteNonQuery()
                                
						RSWrite = New SqlCommand("UPDATE dbo.Songs SET ThemeSong=1 WHERE SongName='" & Request.QueryString("File") & "'", SQLCon)
						'RSWrite = New System.Data.OleDb.OleDbCommand("UPDATE dbo_Songs SET ThemeSong=1 WHERE SongName='" & Request.QueryString("File") & "'", SQLCon)
						RSWrite.ExecuteNonQuery()
						Response.Write("<font color=""red"">" & Request.QueryString("File") & " is now the theme song to the front page.</font >")
					Catch ex As Exception
						Response.Write("Failed to reset the theme song." & ex.ToString)
                                
					End Try
                            
                            
				Else
					''upload song to server
					'Response.Write("</form><form id=""AddSong"" name=""AddSong"" method=""post"" enctype=""multipart/form-data"" action="".\admin.aspx?Page=Music&Action=Add"" > ")
					'Response.Write("Enter a Song Title:  ")
					'Response.Write("<input id=""SongName"" name=""SongName"" type=""Text"" size=""30"" />")
					'Response.Write("<input id=""FileName"" name=""FileName"" type=""File"" />")
					'Response.Write("<input id=""AddBut"" name=""AddBut"" type=""submit"" Value=""Upload"" /><br>")
					'Response.Write("</form>")
                            
				End If

				RSRead = New SqlCommand("SELECT FileName, SongName, ThemeSong, Size, UploadDate FROM dbo.Songs", SQLCon)
				'RSRead = New System.Data.OleDb.OleDbCommand("SELECT FileName, SongName, ThemeSong, [Size], UploadDate FROM dbo_Songs", SQLCon)
				dr = RSRead.ExecuteReader
				If dr.HasRows Then
					'display songs in the system
					Response.Write("<table>")
					Response.Write("<tr>")
					Response.Write("<br><td>Song Title</td><td>File Size</td><td>Upload Date</td>")
					Response.Write("</tr>")
                            
					While dr.Read
						Response.Write("<tr>")
						Response.Write("<td width=""200"">")
						Response.Write("<a href="""" onclick=""window.open('Player.aspx?Song=" & dr.Item("FileName") & "','popUpWindow','Height=30,width=350,left=100,top=100,menubar=0,resizable=0,scrollbars=0,location=0,directories=0, status=1')"">")
						Response.Write(dr.Item("SongName"))
						Response.Write("</a>")
						Response.Write("</td>")
						Response.Write("<td width=""70""> " & dr.Item("Size") & " kb </td>")
						Response.Write("<td width=""150""> " & dr.Item("UploadDate") & "</td>")
						Response.Write("<td>")
                                
						Response.Write("</form><form id=""Musicfrm"" method=""post"" action=""admin.aspx?Page=Music&Action=Theme&File=" & dr.Item("SongName") & """> ")
						If dr.Item("ThemeSong") = 0 Then
							Response.Write("<input id=""Edit"" name=" & dr.Item("SongName") & " type=""submit"" Value=""Make Theme"" />")
						ElseIf dr.Item("ThemeSong") = 1 Then
							Response.Write("Current Theme")
						End If
                                
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("<td>")
						Response.Write("<form id=""Musicfrm"" method=""post"" action=""admin.aspx?Page=Music&Action=Delete&File=" & dr.Item("SongName") & """> ")
						Response.Write("<input id=""Delete"" name=" & dr.Item("SongName") & " type=""submit"" Value=""Delete"" /><br>")
						Response.Write("</form>")
						Response.Write("</td>")
						Response.Write("</tr>")
                             
					End While
					Response.Write("</table>")
                   
                            

				Else
					'return with failure if login info does not match database
					Response.Write("<font color=""red"" style=""color:red"">There are no songs. Click the Choose file button to add songs to the system.</font>")
				End If
				dr.Close()
			Case Else
				Response.Write("<center>Select a Menu option on the left to maintain the web site.</center>")
		End Select
              
        Response.Write("</tr>")
        Response.Write("</table>")
        SQLCon.Close()

    End If
    ''cookie checker
    'Dim tmpcookie As Integer = 0
    'If Request.Cookies.Count > 0 Then
    '    Do Until tmpcookie = Request.Cookies.Count
    '        Response.Write("<p style=""text-align:center"">Cookie Name: " & Request.Cookies(tmpcookie).Name & vbCrLf & "<br>Cookie Value: " & Request.Cookies(tmpcookie).Value & vbCrLf & "<br></p>")
    '        tmpcookie = tmpcookie + 1
    '    Loop
    '    Response.Write("<br><br><br>")
        
    'End If
%>
          
</asp:TableCell>
</asp:TableRow>
</asp:Table>
<br/>
    
<br/>



</asp:Content>
<asp:Content ID="Content4" runat="server" ContentPlaceHolderID="foot">
<p style="text-align:center">
<br /><br /><br /><br /><br /><a href="index.aspx" >Home Page</a>
</p>
</asp:Content>