<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="./Home.Master" CodeFile="Home.aspx.vb" Inherits="HomePage" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="HeaderScripts" ContentPlaceHolderID="Head" runat="server">


</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="BodyHead" runat="server">

    <%
 
        If Request.QueryString("Page") Is Nothing Or Len(Request.QueryString("Page")) = 0  Then Response.Redirect("Http://kisstradingcard.com/Home.aspx?Page=Main")
        
        If Request.QueryString("Page") = "Main" Then
            Response.Write("<img style=""color:white;text-align:center;"" src=""pics\Ace.jpg"" height=""300"" width=""25%"" />")
            Response.Write("<img style=""color:white;text-align:center;"" src=""pics\Gene.jpg"" height=""300"" width=""25%"" />")
            Response.Write("<img style=""color:white;text-align:center;"" src=""pics\Paul.jpg"" height=""300"" width=""25%"" />")
            Response.Write("<img style=""color:white;text-align:center;"" src=""pics\Peter.jpg"" height=""300"" width=""25%"" />")
            Response.Write("<br />")
            Response.Write("<br />")
            Response.Write("<br />")
        End If
        
        %>   

</asp:Content>

<asp:Content ID="MenuLogo" ContentPlaceHolderID="BodyMenu" runat="server">

<img src=".\pics\logo.jpg"/>
</asp:Content>

<asp:Content ID="Links" ContentPlaceHolderID="MenuLinks" runat="server">


    <p style="color:white;">

    <%
        Dim ConnectionString As String = ""
        Dim SQLCon As SqlConnection = New SqlConnection
        Dim RSWrite As SqlCommand = New SqlCommand
        Dim RSRead As SqlCommand = New SqlCommand
        Dim RSRead2 As SqlCommand = New SqlCommand


        Dim dr As SqlDataReader

        Dim SQLSelect As String = ""
        Dim SQLInsert As String = ""
        Dim SQLUpdate As String = ""
        Dim SQLDelete As String = ""
        Dim MenuList As New ListItemCollection
        Dim Menu As New ListItemCollection
        Dim ParentMenu As New ListItemCollection
        Dim SubMenu As New ListItemCollection
        Dim FinalMenu As New ListItemCollection
        Dim c As Long = 0
        Dim c2 As Long = 0
        Dim x As Long = 0
        Dim tmpchk As Integer = 0
        Dim tmpstr As String = ""


        'change all schema first
        'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
        ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;"
        SQLCon = New SqlConnection(ConnectionString)
        SQLCon.Open()


        'has the visitor been here before?
        RSRead = New SqlCommand("SELECT IP FROM dbo.Visitors WHERE IP='" & Request.ServerVariables("REMOTE_ADDR") & "' AND ContentPage='" & Request.QueryString("Page") & "'", SQLCon)
        dr = RSRead.ExecuteReader
        If dr.HasRows Then
            dr.Close()
        Else
            dr.Close()
            RSWrite = New SqlCommand("INSERT INTO dbo.Visitors(IP, VisitDate, ContentPage) VALUES('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Now & "', '" & Request.QueryString("Page") & "')", SQLCon)
            RSWrite.ExecuteNonQuery()
        End If


        'begin menu
        Response.Write("<p>Navigation Menu<br></p>")
        RSRead = New SqlCommand("SELECT ContentPage FROM dbo.Content WHERE MenuLink=1 ", SQLCon)
        dr = RSRead.ExecuteReader

        'get main menu links 
        c = 0
        If dr.HasRows Then
            Do While dr.Read
                'If IsDBNull(dr.Item("MenuName")) Then
                '	MenuList.Add(New ListItem(" "))
                'Else
                'if Request.QueryString("Page") <> "Main" then 
                MenuList.Add(New ListItem(dr.Item("ContentPage")))
                'End If


            Loop

        End If
        dr.Close()

        'get all parent pages for the child page going back to the main page
        ParentMenu.Clear()

        'if not the main page then add current page
        If Request.QueryString("Page") <> "Main" Then ParentMenu.Add(Request.QueryString("Page"))

MainRedo:
        If ParentMenu.Count = 0 Then
            RSRead = New SqlCommand("SELECT ParentPage, ContentPage, MenuName FROM dbo.Content WHERE ContentPage='" & Request.QueryString("Page") & "'", SQLCon)
            dr = RSRead.ExecuteReader
            If dr.HasRows Then
                Do While dr.Read

                    If dr.Item("ParentPage") = "Main" Then GoTo NoReDo

                    ParentMenu.Add(New ListItem(dr.Item("ParentPage")))
                Loop

            Else
                Response.Redirect("/home.aspx?Page=Main")

            End If
            dr.Close()

        Else
            RSRead = New SqlCommand("SELECT ParentPage, MenuName, ContentPage FROM dbo.Content WHERE ContentPage='" & ParentMenu(ParentMenu.Count - 1).Text & "'", SQLCon)
            dr = RSRead.ExecuteReader
            If dr.HasRows Then
                Do While dr.Read
                    If dr.Item("ParentPage") = "Main" Then
                        GoTo NoReDo
                    End If
                    ParentMenu.Add(New ListItem(dr.Item("ParentPage")))


                Loop
            End If
            dr.Close()

        End If

        GoTo MainRedo

NoReDo:
        dr.Close()

        c = 0

        'add parents to the main menu        
        Do Until c = MenuList.Count
            FinalMenu.Add("<a href =""/home.aspx?Page=" & MenuList(c).Text & """>" & MenuList(c).Text & "</a><br>")
            c2 = ParentMenu.Count - 1
            If ParentMenu.Count > 0 Then

                Do Until c2 = -1

                    If MenuList(c).Text = ParentMenu(c2).Text Then
                        RSRead = New SqlCommand("SELECT ContentPage, MenuName FROM dbo.Content WHERE ParentPage='" & ParentMenu(c2).Text & "' ORDER BY ContentPage", SQLCon)
                        dr = RSRead.ExecuteReader
                        If dr.HasRows Then
                            tmpstr = tmpstr & "&nbsp;&nbsp;"
                            Do While dr.Read
                                FinalMenu.Add(tmpstr & "-<a href =""/home.aspx?Page=" & dr.Item("ContentPage") & """>" & dr.Item("MenuName") & "</a><br>")
                            Loop
                        End If
                        dr.Close()
                        c2 = c2 - 1
                    Else
                        If c2 = ParentMenu.Count - 1 Then Exit Do
                        RSRead = New SqlCommand("SELECT ContentPage, ParentPage, MenuName FROM dbo.Content WHERE ParentPage='" & ParentMenu(c2).Text & "' ORDER BY CreationDate DESC", SQLCon)
                        dr = RSRead.ExecuteReader
                        'spacer creator based on how far deep the nest is
                        tmpstr = tmpstr & "&nbsp;&nbsp;"
                        If dr.HasRows Then
                            Do While dr.Read

                                Dim tmpitem As String = tmpstr & "-<a href =""/home.aspx?Page=" & dr.Item("ContentPage") & """>" & dr.Item("MenuName") & "</a><br>"

                                If ParentMenu.Count - 1 = c2 Then
                                    FinalMenu.Add(tmpitem)

                                Else

                                    x = 0

                                    For Each tmpmenu As ListItem In FinalMenu
                                        If tmpmenu.Text Like "*" & dr.Item("ParentPage") & "*" Then
                                            FinalMenu.Insert(x + 1, tmpitem)

                                            Exit For
                                        End If
                                        x = x + 1
                                    Next

                                End If

                            Loop
                        End If
                        dr.Close()
                        c2 = c2 - 1
                    End If

                Loop

            End If
            c = c + 1
        Loop

        'display menu
        c = 0
        Do Until c = FinalMenu.Count
            Response.Write(FinalMenu(c).Text)
            c = c + 1
        Loop

        SQLCon.Close()

        %>

        </p>
</asp:Content>

<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="server">
        <%
            Response.Write("<h1><p style=""style=""color:white;text-align:center;"">")
            If Request.QueryString("Page") <> "Main" Then Response.Write(PageTitle)

            Response.Write("</h1></p><br>")
            %>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="PageContent" runat="server">

	        <%
	        	Response.Write("<p style=""style=""color:white;text-align:center;"">")
            Response.Write(MainMessage)
			Response.Write("</p><br>")
            %>
	
        <%

            Dim ConnectionString As String = ""
            Dim SQLCon As SqlConnection = New SqlConnection
            Dim RSWrite As SqlCommand = New SqlCommand
            Dim RSRead As SqlCommand = New SqlCommand
            Dim RSRead2 As SqlCommand = New SqlCommand
            Dim ContentBlock As String = ""

            Dim dr As SqlDataReader

            Dim SQLSelect As String = ""
            Dim SQLInsert As String = ""
            Dim SQLUpdate As String = ""
            Dim SQLDelete As String = ""



            'change all schema first
            'ConnectionString = "Server=BBARNETT-DELL\TREELOGGER;Database=KissFreak;User Id=ODBC;Password=******;"
            ConnectionString = "Server=KissFreakApp.db.11812707.hostedresource.com;Database=KissFreakApp;User Id=KissFreakApp;Password=******;"
            SQLCon = New SqlConnection(ConnectionString)
            SQLCon.Open()

            RSRead = New SqlCommand("SELECT PayPal, PayPalName, PayPalEmail, PayPalShipping, TaxRate, PayPalPrice FROM dbo.Content WHERE ContentPage='" & Request.QueryString("Page") & "'", SQLCon)
            dr = RSRead.ExecuteReader
            ContentBlock = ""
            If dr.HasRows Then
                Do While dr.Read
                    If dr.Item("PayPal") = 1 Then

                        ContentBlock += "<h4>This is available for purchase!</h4><br></form><form target=""paypal"" action=""https://www.paypal.com/cgi-bin/webscr"" method=""post"" >"
                        ContentBlock += "<input type=""hidden"" name=""cmd"" value=""_cart"">"
                        ContentBlock += "<input type=""hidden"" name=""business"" value=""" & dr.Item("PayPalEmail") & """>"
                        ContentBlock += "<input type=""hidden"" name=""lc"" value=""US"" >"
                        ContentBlock += "<input type=""hidden"" name=""item_name"" value=""" & dr.Item("PayPalName") & """>"
                        ContentBlock += "<input type=""hidden"" name=""amount"" value=""" & dr.Item("PayPalPrice") & """>"
                        ContentBlock += "<input type=""hidden"" name=""currency_code"" value=""USD"">"
                        ContentBlock += "<input type=""hidden"" name=""button_subtype"" value=""products"">"
                        ContentBlock += "<input type=""hidden"" name=""no_note"" value=""0"">"
                        ContentBlock += "<input type=""hidden"" name=""tax_rate"" value=""" & dr.Item("TaxRate") & """>"
                        ContentBlock += "<input type=""hidden"" name=""shipping"" value=""" & dr.Item("PayPalShipping") & """>"
                        ContentBlock += "<input type=""hidden"" name=""add"" value=""1"">"
                        ContentBlock += "<input type=""hidden"" name=""bn"" value=""PP-ShopCartBF:btn_cart_LG.gif:NonHostedGuest"">"
                        ContentBlock += "<input type=""image"" src=""https://www.paypalobjects.com/en_US/i/btn/btn_cart_LG.gif"" border=""0"" name=""submit"" alt=""PayPal - The safer, easier way to pay online!"">"
                        ContentBlock += "<img border=""0"" src=""https://www.paypalobjects.com/en_US/i/scr/pixel.gif"" width=""1"" height=""1"">"
                        ContentBlock += "</form><br>"
                    End If

                Loop


            End If
            dr.Close()

            RSRead = New SqlCommand("SELECT FilePath, Caption, IMGLinkContentPage FROM dbo.GalleryInfo WHERE ContentPage='" & HttpContext.Current.Request.QueryString("Page") & "' AND FilePath NOT LIKE 'Thumbs.db' ORDER BY IMGIndex", SQLCon)
            dr = RSRead.ExecuteReader

            If dr.HasRows Then

                Select Case ContentPageStyle

                    Case "Left"
                        ContentBlock += "<div style=""width:1000px; height:500px;  overflow:auto;"">"
                        ContentBlock += "<table cellspacing=""3"">"
                        ContentBlock += "<tr width=""100%"" >"
                        Do While dr.Read
                            'ContentBlock += "<tr width=""100%"" style=""text-align:left"">"
                            'ContentBlock += "<td>"

                            If dr.Item("IMGLinkContentPage") = "None" Then
                                ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:left"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"

                            Else
                                ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img style=""text-align:left"" src=""" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL").Replace("##DBL", Chr(34)).Replace("##SNG", Chr(39)) & """></a><br>"
                            End If
                            'ContentBlock += "<td>"
                            'ContentBlock += "</tr>"
                            'ContentBlock += "<tr>"
                            'ContentBlock += "<td>"
                            ContentBlock += dr.Item("Caption") & "<br><br>"


                            'ContentBlock += "</td>"
                            'ContentBlock += "</tr>"
                        Loop
                        ContentBlock += "</tr>"
                        ContentBlock += "</table>"
                        ContentBlock += "</div>"

                    Case "Right"

                        ContentBlock += "<div style=""width:1000px; height:500px;  overflow:auto;"">"
                        'ContentBlock += "<table cellspacing=""3"" style=""text-align:Right"">"
                        ContentBlock += "<p style=""text-align:Right;padding:10px;"">"
                        Do While dr.Read
                            'ContentBlock += "<tr width=""100%"" style=""text-align:Right"">"
                            'ContentBlock += "<td style=""text-align:Right"">"

                            'fix quotes
                            Dim newstr As String = dr.Item("FilePath")
                            newstr = newstr.Replace("##DBL", Chr(34))
                            newstr = newstr.Replace("##SNG", Chr(39))

                            If dr.Item("IMGLinkContentPage") = "None" Then

                                ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:Right"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                            Else
                                ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img src=""" & newstr & """></a><br>"
                            End If
                            'ContentBlock += "</td>"
                            'ContentBlock += "</tr>"
                            'ContentBlock += "<tr width=""100%"" style=""text-align:Right"">"
                            'ContentBlock += "<td style=""text-align:Right"">"
                            ContentBlock += dr.Item("Caption") & "<br><br>"
                            'ContentBlock += "</td>"
                            'ContentBlock += "</tr>"
                        Loop
                        ContentBlock += "</p>"
                        'ContentBlock += "</tr>"
                        'ContentBlock += "</table>"
                        ContentBlock += "<div>"

                    Case "Top"
                        ContentBlock += "<div style=""width:1000px; height:300px;  overflow:auto;"">"
                        ContentBlock += "<table cellspacing=""3"">"
                        ContentBlock += "<tr width=""100%"" >"
                        Do While dr.Read
                            'fix quotes
                            Dim newstr As String = dr.Item("FilePath")
                            newstr = newstr.Replace("##DBL", Chr(34))
                            newstr = newstr.Replace("##SNG", Chr(39))

                            ContentBlock += "<td>"
                            If dr.Item("IMGLinkContentPage") = "None" Then
                                ContentBlock += "<a target=""_blank"" href=""Javascript:window.open('/picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & "','menubar=0,scrollbars=0,width=700,height=750')""><img style=""text-align:left"" height=""250"" width=""250"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                            Else
                                ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img src=""" & newstr & """></a><br>"
                            End If
                            'ContentBlock += "<td>"
                            'ContentBlock += "</tr>"
                            'ContentBlock += "<tr>"
                            'ContentBlock += "<td>"
                            ContentBlock += dr.Item("Caption") & ""
                            ContentBlock += "</td>"

                        Loop
                        ContentBlock += "</tr>"
                        ContentBlock += "</table>"
                        ContentBlock += "<div>"

                    Case "Tiles"

                        Dim switchcounter As Integer = 1
                        ContentBlock += "<div style=""width:1100px; height:550px;  overflow:auto;"">"
                        ContentBlock += "<table cellspacing=""3"">"

                        Do While dr.Read

                            'fix quotes
                            Dim newstr As String = dr.Item("FilePath")
                            newstr = newstr.Replace("##DBL", Chr(34))
                            newstr = newstr.Replace("##SNG", Chr(39))


                            If switchcounter = 1 Then
                                ContentBlock += "<tr>"
                            End If

                            ContentBlock += "<td>"
                            If dr.Item("IMGLinkContentPage") = "None" Then
                                ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:left"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                            Else
                                ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img width=""250"" height=""250"" src=""" & newstr & """></a><br>"
                            End If
                            ContentBlock += dr.Item("Caption") & ""
                            ContentBlock += "</td>"
                            If switchcounter >= 4 Then
                                switchcounter = 0
                                ContentBlock += "</tr>"

                            End If

                            switchcounter += 1

                        Loop
                        ContentBlock += "</table>"
                        ContentBlock += "<div>"

                    Case "Staggered"

                        ContentBlock += "<div style=""width:1000px; height:500px;  overflow:auto;"">"
                        Dim switchcounter As Integer = 0

                        Do While dr.Read

                            'fix quotes
                            Dim newstr As String = dr.Item("FilePath")
                            newstr = newstr.Replace("##DBL", Chr(34))
                            newstr = newstr.Replace("##SNG", Chr(39))

                            If switchcounter = 0 Then

                                ContentBlock += "<p style=""text-align:left"">"

                                If dr.Item("IMGLinkContentPage") = "None" Then
                                    ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:left"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                                Else
                                    ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img style=""text-align:Left"" width=""250"" height=""250"" src=""" & newstr & """></a><br>"
                                End If


                                ContentBlock += dr.Item("Caption") & "<br><br>"

                                switchcounter = 1
                                ContentBlock += "</p>"


                            ElseIf switchcounter = 1 Then



                                ContentBlock += "<p style=""text-align:right;padding:10px;"">"

                                If dr.Item("IMGLinkContentPage") = "None" Then
                                    ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:Right"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                                Else
                                    ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img style=""text-align:right;padding:10px;""  width=""250"" height=""250"" src=""" & newstr & """></a><br>"
                                End If

                                ContentBlock += dr.Item("Caption") & "<br><br>"

                                switchcounter = 0
                                ContentBlock += "</p>"


                            End If


                        Loop

                        ContentBlock += "</div>"

                    Case Else


                        ContentBlock += "<div style=""width:1000px; height:500px;  overflow:auto;"">"
                        ContentBlock += "<table cellspacing=""3"">"
                        ContentBlock += "<tr width=""100%"" >"
                        Do While dr.Read

                            'fix quotes
                            Dim newstr As String = dr.Item("FilePath")
                            newstr = newstr.Replace("##DBL", Chr(34))
                            newstr = newstr.Replace("##SNG", Chr(39))


                            'ContentBlock += "<tr width=""100%"" style=""text-align:left"">"
                            'ContentBlock += "<td>"
                            If dr.Item("IMGLinkContentPage") = "None" Then
                                ContentBlock += "<a target=""_blank"" href=""picture.aspx?Picture=" & dr.Item("FilePath").Replace("\", "FSL").Replace("/", "FSL") & """><img width=""250"" height=""250"" style=""text-align:left"" src=""" & dr.Item("FilePath").Replace("##SNG", Chr(39)).Replace("##DBL", Chr(34)) & """></a><br>"
                            Else
                                ContentBlock += "<a href=""home.aspx?Page=" & dr.Item("IMGLinkContentPage") & """><img width=""250"" height=""250"" src=""" & newstr & """></a><br>"
                            End If
                            'ContentBlock += "<td>"
                            'ContentBlock += "</tr>"
                            'ContentBlock += "<tr>"
                            'ContentBlock += "<td>"
                            ContentBlock += dr.Item("Caption") & "<br><br>"
                            'ContentBlock += "</td>"
                            'ContentBlock += "</tr>"
                        Loop
                        ContentBlock += "</tr>"
                        ContentBlock += "</table>"
                        ContentBlock += "<div>"
                End Select
                Response.Write(ContentBlock)
                dr.Close()

                Response.Write("</div>")

            Else
                Response.Write(ContentBlock)
            End If


            %>
		

</asp:Content>

<asp:Content ID="PageFooter" ContentPlaceHolderID="Foot" runat="server">

</asp:Content>
