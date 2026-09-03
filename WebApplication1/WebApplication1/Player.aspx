<%@ Page Language="vb" AutoEventWireup="false" CodeFile="Player.aspx.vb" Inherits="PlayerPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <%Response.Write("<audio class=""audio-player"" src="".\Songs\" & Request.QueryString("Song") & """ autoplay=""autoplay"" controls />")

      %>
    </div>
    </form>
</body>
</html>
