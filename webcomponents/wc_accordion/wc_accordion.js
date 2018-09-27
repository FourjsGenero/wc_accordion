"use strict";

//% var has_focus = false;

/*
** Accordion_Activate: Activate the accordion widget
*/
function Accordion_Activate()
{
  var acc = document.getElementsByClassName("accordion");

  for (var i = 0; i < acc.length; i++)
    {
    acc[i].addEventListener("click", function()
      {
      this.classList.toggle("active");
      var panel = this.nextElementSibling;
      if (panel.style.maxHeight)
        panel.style.maxHeight = null;
      else
        panel.style.maxHeight = panel.scrollHeight + "px";
      });
    }
}


/*
** onICHostReady: gICAPI interface
** @param {string} version
*/
var onICHostReady = function(p_version)
  {

    if (p_version != "1.0")
      {
      alert('Invalid API version');
      }

    // When the DVM set/remove the focus to/from the component
    gICAPI.onFocus = function(p_polarity)
      {
      if (p_polarity)
        document.body.style.border = '1px solid blue';
      else
        document.body.style.border = '1px solid grey';
      }

    // When the component property changes
    gICAPI.onProperty = function(p_property)
      {
      var o_prop = eval('(' + p_property + ')');

      if (o_prop.title)
        $("#Title").html(o_prop.title).show();
      if (o_prop.narrative)
        $("#Narrative").html(o_prop.narrative).show();
      }

    // When field data changes
    gICAPI.onData = function(p_value)
      {
      // Reset: clear or hide everything
      $(".sections").remove();
        
      if (p_value)
        {
        // data defined, grab Accordion record
        var r_data = JSON.parse(p_value);

        // Title
        if (r_data.title)
          {
          $("#Title").html(r_data.title);
          $("#Title").show();
          }
          
        // Narrative
        if (r_data.narrative)
          {
          $("#Narrative").html(r_data.narrative);
          $("#Narrative").show();
          }

        // Sections
        $(document.body).append('<div class="sections"></div>');
        for (var idx = 0; idx < r_data.sections.length; idx++)
          {
          $(".sections").append('<div class="section"><button class="accordion">'
            + r_data.sections[idx].name
            + '</button><div class="panel"><p> '
            + r_data.sections[idx].content
            + ' </p></div></div>');
          }
          Accordion_Activate();
        }
      }

    // Init
    $("#Title").hide();
    $("#Narrative").hide();
  }
