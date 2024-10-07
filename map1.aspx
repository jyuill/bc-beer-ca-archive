<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" Title="Untitled Page" %>




<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAE59FlUHG7ZvMGPlXgI3BzhR0LFBqkeT5mHcK0iEEJBeoA4FVRxQfNwUl8cBHVDoe98Q-NIOOrwiuVA"
      type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
        map.setCenter(new GLatLng(37.4419, -122.1419), 13);
      }
    }
    //]]>
    </script>
    
    <div id="map" style="width: 500px; height: 300px"></div>

</asp:Content>

