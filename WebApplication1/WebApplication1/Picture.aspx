<%@ Page Language="vb" AutoEventWireup="false" CodeFile="Picture.aspx.vb" Inherits="PicturePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <%
     	 'Response.Write(Request.QueryString("Picture"))
     	 Response.Write("<img src=""" & Request.QueryString("Picture").Replace( "FSL","/").Replace("%20", " ").Replace("##DBL", Chr(34)).Replace("##SNG", Chr(39)) & """>")%>
    </div>
    </form>
</body>
</html>
