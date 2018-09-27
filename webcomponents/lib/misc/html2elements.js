/*
** @param {String} HTML representing any number of sibling elements
** @return {NodeList} 
*/
function htmlToElements(p_html)
{
  var o_template = document.createElement('template');
  
  o_template.innerHTML = p_html.trim();
  return o_template.content.children;
}

