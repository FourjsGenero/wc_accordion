"use strict";


/*
** Initialize Accordion options
*/
$(function()
{
  $('#accordion').accordion({
    collapsible: false,
    icons: null
  });
});



/*
** onICHostReady: gICAPI interface
** @param {string} version
*/
var onICHostReady = function(p_version) {

    if (p_version != "1.0")
      {
      alert('Invalid API version');
      }
      
    // When the DVM set/remove the focus to/from the component
    gICAPI.onFocus = function(p_polarity)
      {
      /* %M: Focus is on internal elements, not container, so skip */
      }

    // When the component property changes
    gICAPI.onProperty = function(p_property)
      {
      var o_prop = eval('(' + p_property + ')');
      // document.getElementById("Title").innerHTML = o_prop.title;
      $("#Title").html(o_prop.title);
      $("#Narrative").html(o_prop.narrative);
      }

    // When field data changes
    gICAPI.onData = function(p_value)
      {
      // Reset: clear or hide everything
      $('#Title').hide();
      $('#Narrative').hide();
      $('#accordion').children().remove();
        
      if (p_value)
        {
        // data defined, grab Accordion record
        var r_data = JSON.parse(p_value);

        // Title
        if (r_data.title)
          {
          $('#Title').html(r_data.title);
          $('#Title').show();
          }
          
        // Narrative
        if (r_data.narrative)
          {
          $('#Narrative').html(r_data.narrative);
          $('#Narrative').show();
          }

        // Sections
        for (var idx = 0; idx < r_data.sections.length; idx++)
          {
          $('#accordion').append('<h3>' + r_data.sections[idx].name + '</h3>');
          $('#accordion').append('<div>' + r_data.sections[idx].content + '</div>');
          }
          Refresh();
        }
      }
}




//
// PUBLIC
//

/*
** Collapsible: Set if all sections are collapsible or not
** @param {boolen} TRUE if all sections collapsible, else FALSE
*/
function Collapsible(p_collapse)
{
  $('#accordion').accordion('option', 'collapsible', p_collapse);
  Refresh();
}


/*
** Icons: Set icons for section headers
** @param {string} Name of ui-icon for CLOSED state
** @param {string} Name of ui-icon for OPEN state
** List of Icons:
** https://api.jqueryui.com/resources/icons-list.html
*/
function Icons(p_closed, p_open)
{
  var p_blank = 'ui-icon-blank';
  
  if (!p_closed && !p_open)
    // Both undefined, then remove icons
    $('#accordion').accordion('option', 'icons', null);
  else
    // Set icons, defaulting to blank if one is undefined
    $('#accordion').accordion('option', 'icons', {'header': p_closed || p_blank, 'activeHeader': p_open || p_blank });

  Refresh();
}

/*
** Refresh: Refresh the Accordion
*/
function Refresh()
{
  $('#accordion').accordion('refresh');
}




