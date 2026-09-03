<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="./Index.Master" CodeFile="Index.aspx.vb" Inherits="IndexPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">

    <p style="color:white;text-align:center">
        <%'Click to Enter the world of the Kiss Freak%>
    </p>
    

    <p style="text-align:center;">
        <a href="Home.aspx?Page=Main" >
                <%Response.Write("<img src="".\pics\" & SplashImage & """ height=""656"" width=""819""/>")%>   
        </a>
        <br />
    </p>
    <% Response.Write("<center><font color=""white"">" & counter & "</font></center>")%>
    <a href="admin.aspx"><p style="text-align:center">Admin</p>   
        </a>
    <%Response.Write("<audio id=""ThemeSong"" class=""audio-player"" src="".\Songs\" & ThemeMusic & """ />")%>   
      <script>
          var ThemeSong = document.getElementById("ThemeSong");
          ThemeSong.volume = .15;
          ThemeSong.play();
      </script>
    <br /><br /><br /><br />

    
</asp:Content>
