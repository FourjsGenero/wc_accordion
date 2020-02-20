"use strict";

// Options
var g_showSiblings = 0;       // only show one sibling
var g_collapseKids = true;    // to collapse all descedents if parent collapsed
var g_slideTime = 350;        // slide transition time in ms
var g_showFocus = false;       // show focus indicator or not

// Defaults
var g_imagePath = '';         // Path to images prefix
var g_iconClosed = '';        // Default close icon
var g_iconOpen = '';          // Default open icon

// State
var g_focus = false;          // if Widget has the focus or not
var g_setData = '';           // Buffer to defer set data until focus




/*
** html_Icons: Returns the HTML for the open and closed Icons
** @param {string} ui-icon for Open state
** @param {string} ui-icon for Closed state
** @param {boolean} if initial state is Open
** @return {html} HTML image tag for both images
*/
function html_Icons(p_iconOpen, p_iconClosed, p_open)
{
  // Current state
  var p_displayClosed = (p_open == 'open') ? 'style="display: none"' : '';
  var p_displayOpen = (p_open == 'open') ? '' : 'style="display: none"';

//alert('state=' + p_open + '\nclosed=' + p_displayClosed + '\nopen=' + p_displayOpen);

  // Set icons, if defined
  var p_tagClosed = p_iconClosed || g_iconClosed;
  var p_tagOpen = p_iconOpen || g_iconOpen;
  if (p_tagClosed) p_tagClosed = '<span icon="closed" class="ui-icon ' + p_tagClosed + '" ' + p_displayClosed + '/>';
  if (p_tagOpen) p_tagOpen = '<span icon="open" class="ui-icon ' + p_tagOpen + '" ' + p_displayOpen + '/>';

  return p_tagOpen + p_tagClosed;
}


/*
** html_Image: Returns the HTML for image tag
** @param {string} image name
** @return {html} HTML image tag for image
*/
function html_Image(p_image)
{
  if (!p_image)
    return '';

  var p_path = g_imagePath || '';
  if (p_image.startsWith('http') || p_image.startsWith('/'))
    p_path = p_image;
  else
    p_path = p_path + '/' + p_image;

  return ('<img src="' + p_path + '" class="icon"/> ');
}


/*
** html_ItemBegin: Returns the HTML for the Header and start of Item container
** @param {string} Item ID
** @param {string} Text attribute
** @param {string} Image attribute
** @param {string} Icon for Open state
** @param {string} Icon for Closed state
** @param {boolean} if initial state is Open
*/
function html_ItemBegin(p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open)
{
  // build HTML content for container
  var p_html = '<li class="outer"><a id="'
    + p_id.trim()
    + '" class="toggle" href="javascript:void(0);">'
    + html_Icons(p_iconOpen, p_iconClosed, p_open)
    + html_Image(p_image)
    + '<span class="label">' + p_text + '</span>'
    + '</a><ul class="inner">';

  return p_html;
}


/*
** html_ItemContent: Returns the HTML for Item's contents
** @param {html} Item's HTML contents
** @return {html} HTML for container and contents
*/
function html_ItemContent(p_content)
{
  return '<div class="content">' + (p_content || '') + '</div>';
}


/*
** html_ItemEnd: Returns the closing tag for an Item
** @return {html} HTML for closing container
*/
function html_ItemEnd()
{
  return '</ul></li>';
}


/*
** item_Current: Sets the CURSOR to current item & opens parents so its visible
** @param {Object} jQuery object of item
*/
function item_Current(o_item)
{
  if (!o_item)
    return;

  var $o_item = $(o_item);

  // Parents have to be visible
  $o_item.parents('ul.inner').addClass('show');
  $o_item.parents('ul.inner').slideDown(g_slideTime);
    
  // Close siblings if g_showSiblings < 2
  if (g_showSiblings < 2)
    {
    //%TBD
    }

  // Set Cursor to Highlight just this Item
  $('li.outer').removeClass('select');
  $o_item.parent().addClass('select');
}


/*
** item_Events: Set event handlers for Item events
** @param {string} jQuery selector
*/
function item_Events(p_selector)
{
  // reset in case we call more than once on the same item
  $(p_selector).off('click').off('dblclick');
  
  // <a>.Click
  $(p_selector).click(function(e)
    {
    var that = this;
    setTimeout(function()
      {
        var dblclick = parseInt($(that).data('double'), 10);
        if (dblclick > 0)
          $(that).data('double', dblclick-1);
        else
          item_Select.call(that, e);
      }, 300);
    });

  // <a>.DoubleClick
  $(p_selector).dblclick(function(e)
    {
    $(this).data('double', 2);
    item_Select.call(this, e);
    item_Show(this);
    });
    
  // <a><span class="ui-icon">.Click
  $(p_selector).children('span.ui-icon').click(function(e)
    {
    item_Select.call($(this).parent(), e);
    item_Show($(this).parent());
    });
}
//%T if (typeof(gICAPI) == 'undefined') item_Events(".toggle");


/*
** item_Select: Sets data to Item, sends SELECT action
** @param {Event} handler
*/
function item_Select(e)
{
  e.preventDefault();
  
  var $this = $(this);

  // Must have focus to SetData, otherwise ignored
  gICAPI.SetFocus();
  
  //%D    alert('item_Select=' + $this.prop('tagName') + ':' + $this.prop('id'));
  
  // Set data to current item ID and send action if we have focus, otherwise defer
  if (g_focus)
    {
    gICAPI.SetData($this.attr('id'));
    gICAPI.Action('select');
    }
  else
    g_setData = $this.attr('id');
}


/*
** item_Show: Show or hide contents
** @param {Object} DOM object of item %%%TBFixed as jQuery Object?
** @param {boolean} true if show, else hide
*/
function item_Show(o_item, p_show)
{
  //%D alert('item_Show');
  if (!o_item)
    return;
    
  var $o_item = $(o_item);

  // if p_show not defined, then default is to Toggle visibility
  if (p_show == null)
    {
    if ($o_item.next().hasClass('show'))
      return item_Show(o_item, false);
    else
      return item_Show(o_item, true);
    }

  if (p_show)
    {    
    // Open this
    $o_item.next().addClass('show');
    $o_item.next().slideDown(g_slideTime);
    $o_item.find('[icon="open"]').show();
    $o_item.find('[icon="closed"]').hide();
    }
  else
    {
    // Hide contents
    $o_item.next().removeClass('show');
    $o_item.next().slideUp(g_slideTime);
    $o_item.find('[icon="closed"]').show();
    $o_item.find('[icon="open"]').hide();
    }
}


/*
** item_IsVisible: Are contents of an item visible?
** @param {Object} jQuery object of item
** @return {boolean} TRUE if visible, else FALSE
*/
function item_IsVisible(o_item)
{
  if (!o_item)
    return false;

  return $(o_item).next().hasClass('show');
}


/*
** item_Add: Add a child Item to a parent Item
** @param {Object} jQuery object of item
** @param {string} Parent Item ID
** @param {string} Item ID
** @param {string} Text attribute
** @param {string} Image attribute
** @param {string} Icon for Open state
** @param {string} Icon for Closed state
** @param {string} Initial state of node
** @param {html} Content for this node
*/
function item_Add(o_parent, p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content)
{
  var p_html = html_ItemBegin(p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open)
    + html_ItemContent(p_content)
    + html_ItemEnd();

  // ul = a:next sibling
  // insert before child ul/div.content
  //%D: alert($(o_parent).next('.inner').children('div.content').html());
  if (o_parent)
    $(o_parent).next('.inner').children('div.content').before(p_html);
  else
    $('.accordion').append(p_html);

  // Enable toggle on new node
  item_Events('#' + p_id.trim() + '.toggle');
}


/*
** item_Delete: Delete an item and its descendents
** @param {Object} jQuery object of item
*/
function item_Delete(o_item)
{
  if (!o_item)
    return;
    
  $(o_item).parent().remove();
}


/*
** item_Set: Update an Item
** @param {Object} jQuery object of item
** @param {string} Text attribute
** @param {string} Image attribute
** @param {string} Icon for Open state
** @param {string} Icon for Closed state
** @param {string} Initial state of node
** @param {html} Content for this node
*/
function item_Set(o_item, p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content)
{
  if (!o_item)
    return;

  var $o_item = $(o_item);

  // Label and image
  $o_item.children('span.label').html(p_text);
  $o_item.children('img').replaceWith(html_Image(p_image));

  // Get state, and set Icons if defined
  var p_icons = html_Icons(p_iconOpen, p_iconClosed, item_IsVisible(o_item));
  $o_item.children('span.ui-icon').remove();
  if (p_icons) $o_item.prepend(p_icons);

  // Set content
  $o_item.next('.inner').children('div.content').html(p_content);

  // Have to reset item events as icons may have been replaced or are new
  item_Events($o_item);
}


/*
** node_Load: recursively builds HTML
** @param {Object[]} DOM element
** @return {HTML} html content
*/
function node_Load(o_node)
{
  var oa_kids = o_node.children;
  var p_html = '';
  
  // for each child node
  for (var idx = 0 ; idx < oa_kids.length ; idx++)
    {
    // Start of Item container
    p_html += html_ItemBegin(oa_kids[idx].getAttribute("id").trim(),
      oa_kids[idx].getAttribute("text"),
      oa_kids[idx].getAttribute('image'),
      oa_kids[idx].getAttribute('iconOpen'),
      oa_kids[idx].getAttribute('iconClosed'),
      oa_kids[idx].getAttribute('state'));

    // + recursively process descendent nodes
    p_html += node_Load(oa_kids[idx]);

    // + content and end
    p_html += html_ItemContent(oa_kids[idx].getAttribute('content')) + html_ItemEnd();
    }

  return p_html;
}


/*
** onICHostReady: gICAPI interface
** @param {string} version
*/
var onICHostReady = function(p_version)
  {
  if (p_version != '1.0')
    alert('Invalid API version');
  
  // When the DVM set/remove the focus to/from the component
  gICAPI.onFocus = function(p_polarity)
    {
    /* %M: Focus is on elements inside container */
    if (p_polarity)
      {
      g_focus = true;
      if (g_showFocus)
        $('body').css('border', '3px solid #7FAFEB');

      // Used to send Data only when we have focus
      if (g_setData)
        {
        gICAPI.SetData(g_setData);
        gICAPI.Action('select');
        g_setData = '';
        }
      }
    else
      {
      g_focus = false;
      if (g_showFocus)
        $('body').css('border', 'none');
      }
    }

  // When the component property changes
  gICAPI.onProperty = function(p_property)
    {
    var o_prop = eval('(' + p_property + ')');
    $('#Title').html(o_prop.title);
    $('#Narrative').html(o_prop.narrative);
    if (o_prop.showfocus)
      g_showFocus = true;
    }

  // When field data changes
  gICAPI.onData = function(p_value)
    {
    if (p_value != null)
      // Field value is ID of current item
      item_Current($('a#' + p_value).get(0));
    }

    
  /*
  ** Initialize
  */
  // touching the WC should set focus
    // <a><span class="ui-icon">.Click
  $('body').click(function(e)
    {
    gICAPI.SetFocus();
    });

  // Title to de-select ("root")
  $('div.header').click(function(e)
    {
    $('li.outer').removeClass('select');
    gICAPI.SetData('');
    gICAPI.Action('select');
    });
  }



  
//
//
//    PUBLIC    ///////////////////////////
//
//


/*
** Item_Add       Add an item to a node by ID
** @param {string} Item ID
** @param {string} Text attribute
** @param {string} Image attribute
** @param {string} Icon for Open state
** @param {string} Icon for Closed state
** @param {string} Initial state of node
** @param {html} Content for this node
*/
function Item_Add(p_parentId, p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content)
{
  var $o_parent;
  
  if (p_parentId)
    $o_parent = $('#' + p_parentId).get(0);

  //Add new item to parent
  item_Add($o_parent, p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content)
}


/*
** Item_Delete  Delete an item by ID
** @param {string} ID of node to delete
*/
function Item_Delete(p_id)
{
  if (!p_id)
    return;

  // Get item and Delete
  item_Delete($('a#' + p_id).get(0));
}


/*
** Item_Set     Update an item by ID
** @param {string} ID of node, default is root node
** @param {string} Text attribute
** @param {string} Image attribute
** @param {string} Icon for Open state
** @param {string} Icon for Closed state
** @param {string} Initial state of node
** @param {html} Content for this node
*/
function Item_Set(p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content)
{
  if (!p_id)
    return;

  /* %D
  alert('id=' + p_id
    + '\ntext=[' + p_text + ']'
    + '\nimage=' + p_image  
    + '\niconOpen=' + p_iconOpen   
    + '\niconClosed=' + p_iconClosed
    + '\nstate=' + p_open
    + '\ncontent=' + p_content);
  */

  item_Set($('a#' + p_id).get(0), p_text, p_image, p_iconOpen, p_iconClosed, p_open, p_content);
}


/*
** Collapse  Collapse all nodes from a node id
** @param {string} ID of node, default is root node
*/
function Collapse(p_id)
{
  // Get outer container
  var $o_outer = $(p_id ? 'a#' + p_id : 'body').parent();

  // Hide inner container and switch icons
  $o_outer.find('.inner').removeClass('show');
  $o_outer.find('.inner').slideUp(g_slideTime);
  $o_outer.find('[icon="closed"]').show();
  $o_outer.find('[icon="open"]').hide();
}


/*
** Expand: Expand all nodes from a node id
** @param {string} ID of node, default is root node
*/
function Expand(p_id)
{
  // Get outer container
  var $o_outer = $(p_id ? 'a#' + p_id : 'body').parent();

  $o_outer.find('.inner').removeClass('show').addClass('show');
  $o_outer.find('.inner').slideDown(g_slideTime);
  $o_outer.find('[icon="open"]').show();
  $o_outer.find('[icon="closed"]').hide();
}


/*
** IsVisible: If the contents of node specified by ID is visible or not
** @param {string} node ID in the tree
** @return {boolean} TRUE if visible, else FALSE 
*/
function IsVisible(p_id)
{
  return item_IsVisible($('a#' + p_id).get(0));
}


/*
** Set: Set contents of the widget specified by xmlDoc
** @param {string} XML document of the contents 
*/
function Set(p_xmlDoc)
{
  // Some data, grab Accordion record
  var o_parser = new DOMParser();
  var o_xml = o_parser.parseFromString(p_xmlDoc,'text/xml');
  var o_root = o_xml.getElementsByTagName('TreeCordion')[0];

  // If XML doc is valid
  if (o_root)
    {
    // Set Title
    var p_title = o_root.getAttribute('title');
    if (p_title)
      {
      $('#Title').html(p_title);
      $('#Title').show();
      }

    // Set Narrative
    var p_narrative = o_root.getAttribute('narrative');
    if (p_narrative)
      {
      $('#Narrative').html(p_narrative);
      $('#Narrative').show();
      }

    // Icons & images
    g_imagePath = o_root.getAttribute('imagePath') || '';
    g_iconClosed = o_root.getAttribute('iconClosed') || '';
    g_iconOpen = o_root.getAttribute('iconOpen') || '';
    
    // Create accordion tree and activate button toggles
    //%D alert(node_Load(o_root));
    $('.accordion').html(node_Load(o_root));
    $('[icon="open"]').hide();
    item_Events('.toggle');
    }
}


/*
** Show: Show or hide contents of node specified by ID
** @param {string} node ID in the tree
** @param {boolean} true to show, else hide 
*/
function Show(p_id, p_show)
{
  item_Show($('a#' + p_id).get(0), p_show);
}


