<!--This user control includes email address for use on all pages-->
<%@ Control %>

<div class="socialbutton">
    <!-- AddThis Button BEGIN -->
    <div class="addthis_toolbox addthis_default_style addthis_16x16_style">
    <a class="addthis_button_facebook"></a>
    <a class="addthis_button_twitter"></a>
    <a class="addthis_button_pinterest_share"></a>
    <a class="addthis_button_google_plusone_share"></a>
    </div>
    <!-- this script section for AddThis social plugin tracking in GA -->
    <script type="text/javascript">
        var addthis_config = {
            data_ga_property: 'UA-3371059-1',
            data_ga_social: true
        }; 
    </script>
    <script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=undefined"></script>
    <!-- AddThis Button END -->
 </div>
<span class="mail">
<span class="ital">Comments, questions, suggestions? </span>
<!--The unusual method of setting up 'mailto' below is devised to fool email trawlers -->
<a class="mail" onmouseover="this.href='mai' + 'lto:' + 'john' + '@' + 'bcbeer.ca'" href="mail.html">
e-mail me!</a> 
</span>
