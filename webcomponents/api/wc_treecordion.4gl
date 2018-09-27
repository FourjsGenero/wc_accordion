import util

#
# Type Defs
#
public type
  -- TreeCordian data structure
  tTreeCordion record
    id string,            # Currently selected node ID
    field string,         # Form field name
    title string,         # Title text
    narrative string,     # Narrative or description
    imagePath string,     # Local file or URL image prefix
    iconOpen string,      # Default ui-icon for open state
    iconClosed string,    # Default ui-icon for closed state
    doc om.DomDocument,   # DOM document
    dom om.DomNode,       # Root DomNode of DOM document
    Id_New function(p_id string) returns string     # Last Id for generating next ID
  end record,
  -- Item
  tItem record
    id string,            # Node ID
    key string,           # Alternate key (eg. primary key of a record, UUID)
    text string,          # Text label
    image string,         # Name of image resource
    iconOpen string,      # Local ui-icon for open state
    iconClosed string,    # Local ui-icon for closed stste
    state string,         # Current state of Item
    content string        # HTML content
  end record

# Module
private
  define
    m_lastId integer



#
# PUBLIC METHODS
#    

#
#! Init
#+ Initialize the widget
#+
#+ @code
#+ call wc_actree.Init()
#
public function Init()
  
end function


#
#! Create
#+ Creates a new instance of TreeCordion
#+
#+ @param p_field     Form name of the field
#+ @returnType        tTreeCordion
#+ @return            TreeCordion record
#+
#+ @code
#+ define r_acc wc_treecordion.tTreeCordion
#+ call wc_treecordion.Create("formonly.p_treecordion") returning r_acc.*
#
public function Create(p_field string) returns tTreeCordion

  define
    r_tree tTreeCordion

  let r_tree.field = p_field
  let r_tree.doc = om.DomDocument.create("TreeCordion")
  let r_tree.dom = r_tree.doc.getDocumentElement()
  let r_tree.Id_New = function id_New   # Default internal

  return r_tree.*
  
end function


#
#! Clear
#+ Clear record: reset attributes on root node, and delete all children
#+
#+ @param r_tree    TreeCordion instance
#+
#+ @code
#+ define r_acc wc_treecordion.tTreeCordion
#+ call wc_treecordion.Clear(r_acc.*)
#
public function Clear(r_tree tTreeCordion)

  -- reset attributes on root node, and delete all children

  if r_tree.dom is not NULL
  then
    call r_tree.dom.removeChild(r_tree.dom)
    let r_tree.dom = r_tree.doc.getDocumentElement()
  end if
  
end function


#
#! Set
#+ Set initial contents of widget
#+
#+ @param r_tree  TreeCordion instance
#+
#+ @code
#+ define r_acc tTreeCordion
#+ let r_acc.title = "Title"
#+ ...
#+ call wc_treecordion.Set(r_acc.*)
#
public function Set(r_tree tTreeCordion)

  call r_tree.dom.setAttribute("title", r_tree.title)
  call r_tree.dom.setAttribute("narrative", r_tree.narrative)
  call r_tree.dom.setAttribute("imagePath", r_tree.imagePath)
  call r_tree.dom.setAttribute("iconClosed", r_tree.iconClosed)
  call r_tree.dom.setAttribute("iconOpen", r_tree.iconOpen)
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Set", XML(r_tree.*)], [])
  
end function


#
#! Show
#+ Show or hide a node
#+
#+ @param r_tree    TreeCordion instance
#+ @param p_id      Node ID
#+ @param p_show    TRUE to show, else hide
#+
#+ @code
#+ define r_acc tTreeCordion
#+ call wc_treecordion.Show(r_acc.*, "1", TRUE)
#
public function Show(r_tree tTreeCordion, p_id string, p_show boolean)
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Show", p_id, p_show], [])
end function


#
#! IsVisible
#+ Is contents of node visible?
#+
#+ @param r_tree    TreeCordion instance
#+ @param p_id      Node ID
#+
#+ @returnType boolean
#+ @return TRUE if visible, else FALSE
#+
#+ @code
#+ define r_acc tTreeCordion
#+ if wc_treecordion.IsVisible(r_acc.*, "2")
#+ then
#+   message "contents of item 2 is visible"
#+ end if
#
public function IsVisible(r_tree tTreeCordion, p_id string)
  define
    p_visible boolean
    
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "IsVisible", p_id], [p_visible])

  return p_visible
end function


#
#! Expand
#+ Expand node, default is root node (all)
#+
#+ @param r_tree    TreeCordion instance
#+ @param p_id      Node ID
#+
#+ @code
#+ define r_acc tTreeCordion
#+ call wc_treecordion.Expand(r_acc.*, "1")
#
public function Expand(r_tree tTreeCordion, p_id string)
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Expand", p_id], [])
end function


#
#! Collapse
#+ Collapse node, default is root node (all)
#+
#+ @param r_tree    TreeCordion instance
#+ @param p_id      Node ID
#+
#+ @code
#+ define r_acc tTreeCordion
#+ call wc_treecordion.Collapse(r_acc.*, "1")
#
public function Collapse(r_tree tTreeCordion, p_id string)
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Collapse", p_id], [])
end function


#
#! Item_Add 
#+ Add a child Item to a parent Item
#+
#+ @param r_tree        TreeCordion instance
#+ @param p_parentId    Parent Item ID
#+ @param p_id          Item ID
#+ @param p_key         Alternate key
#+ @param p_text        Text attribute
#+ @param p_image       Image attribute
#+ @param p_iconOpen    Icon for Open state
#+ @param p_iconClosed  Icon for Closed state
#+ @param p_state       Initial state of node (NOT CURRENTLY USED)
#+ @param p_content     Content for this node
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ define  r_tree tTreeCordion, p_parentId, p_id integer
#+ call wc_treecordion.Item_Add(r_tree.*, p_parentId, p_id:=p_id+1, "", "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
#
public function Item_Add(r_tree tTreeCordion, p_parentId string, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)

  define
    o_parent om.DomNode,
    o_item om.DomNode

  -- Find the parent node by ID
  let o_parent = Node(r_tree.*, p_parentId)
  if o_parent is NULL
  then
    let o_parent = r_tree.dom
  end if

  if p_parentID = p_id
  then
    let p_id = NULL
  end if
  
  -- New ID?
  let p_id = r_tree.Id_New(p_id)

  -- Parent and child can't have the same ID
  if p_parentId = p_id
  then
    return ""
  end if

  -- Check if Id has been used before
  if Node(r_tree.*, p_id) is not NULL
  then
    return ""
  end if
  
  -- Add the Node
  let o_item = Node_Add(o_parent, p_id, p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)
  
  -- Refresh the New Item in Widget
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Item_Add", p_parentId, p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content], [])

  return p_id
  
end function


#
#! Item_Delete
#+ Delete an Item and its descendents by ID
#+
#+ @param r_tree        TreeCordion instance
#+ @param p_id          Item ID
#+
#+ @code
#+ define  r_tree tTreeCordion, p_id integer
#+ call wc_treecordion.Item_Add(r_tree.*, p_parentId, p_id:=p_id+1, "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
#
public function Item_Delete(r_tree tTreeCordion, p_id string) returns string

  define
    o_item om.DomNode,
    o_parent om.DomNode,
    o_next om.DomNode
    
    
  -- Find the parent node by ID
  let o_item = Node(r_tree.*, p_id)
  if o_item is NULL
  then
    return NULL
  end if
  let o_parent = o_item.getParent()

  -- Refresh to remove Item form Widget
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Item_Delete", p_id], [])

  -- Find the next "current" node once item has been deleted
  -- Try previous sib, next sib, otherwise parent
  let o_next = NVL(NVL(o_item.getPrevious(), o_item.getNext()), o_parent)

  -- Remove the Node
  call o_parent.removeChild(o_item)

  -- Return what should be the next current id
  return o_next.getAttribute("id")
  
end function


#
#! Item_Get
#+ Get an Item by ID
#+
#+ @param r_tree        TreeCordion instance
#+ @param p_id          Item ID
#+
#+ @returnType tItem
#+ @return Record of the item node
#+
#+ @code
#+ define  r_tree tTreeCordion, p_id integer
#+ call wc_treecordion.Item_Get(r_tree.*, p_id)
#
public function Item_Get(r_tree tTreeCordion, p_id string) returns tItem

  define
    r_item tItem,
    o_item om.DomNode

  -- Get node
  let o_item = Node(r_tree.*, p_id)

  -- Extract all the attributes
  if (o_item is not NULL)
  then
    let r_item.id = o_item.getAttribute("id")
    let r_item.key = o_item.getAttribute("key")
    let r_item.text = o_item.getAttribute("text")
    let r_item.image = o_item.getAttribute("image")
    let r_item.iconOpen = o_item.getAttribute("iconOpen")
    let r_item.iconClosed = o_item.getAttribute("iconClosed")
    let r_item.state = iif(IsVisible(r_tree.*, p_id), 'open', 'closed')
    let r_item.content = o_item.getAttribute("content")
  end if
  
  return r_item.*
  
end function


#
#! Item_Update
#+ Update attributes of an Item
#+
#+ @param r_tree        TreeCordion instance
#+ @param p_id          Item ID
#+ @param p_key         Alternate key
#+ @param p_text        Text attribute
#+ @param p_image       Image attribute
#+ @param p_iconOpen    Icon for Open state
#+ @param p_iconClosed  Icon for Closed state
#+ @param p_state       Initial state of node (NOT CURRENTLY USED)
#+ @param p_content     Content for this node
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ 
#+ define r_tree tTreeCordion, p_id integer
#+ call wc_treecordion.Item_Update(r_tree.*, p_id, "SecA", "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
#
public function Item_Update(r_tree tTreeCordion, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)

  define
    o_item om.DomNode

  -- Find the node by ID
  let o_item = Node(r_tree.*, p_id)
  if o_item is NULL
  then
    return
  end if

  -- Set attributes of Node
  call Node_Set(o_item, p_id, p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)
  
  -- Refresh the Item in Widget
  call ui.Interface.frontCall("webcomponent", "call", [r_tree.field, "Item_Set", p_id, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content], [])
  
end function


#
#! Node
#+
#+ @param r_tree        TreeCordion instance
#+ @param p_id          Item ID
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#
public function Node(r_tree tTreeCordion, p_id string)

  define
    ol_nodes om.NodeList

  if p_id.getLength()
  then
    let ol_nodes = r_tree.dom.selectByPath("//Node[@id='" || p_id || "']")
    if ol_nodes.getLength()
    then
      -- return just the first node
      return ol_nodes.item(1)
    end if
  end if

  return NULL
  
end function


#
#! Node_Add 
#+ Add a child node to a parent node
#+
#+ @param o_parent      Parent DOM node
#+ @param p_id          Node ID
#+ @param p_key         Alternate key
#+ @param p_text        Text attribute
#+ @param p_image       Image attribute
#+ @param p_iconOpen    Icon for Open state
#+ @param p_iconClosed  Icon for Closed state
#+ @param p_state       Current state of node (NOT CURRENTLY USED)
#+ @param p_content     Content for this node
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ define  a_nodes dynamic array of om.DomNode,
#+ let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
#
public function Node_Add(o_parent om.DomNode, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string) returns om.DomNode

  define
    o_child om.DomNode

  let o_child = o_parent.createChild("Node")
  call Node_Set(o_child, p_id, p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)

  return o_child
  
end function


#
# Node_Set      Set node attributes
#+
#+ @param o_parent      Parent DOM node
#+ @param p_id          Node ID
#+ @param p_key         Alternate key
#+ @param p_text        Text attribute
#+ @param p_image       Image attribute
#+ @param p_iconOpen    Icon for Open state
#+ @param p_iconClosed  Icon for Closed state
#+ @param p_state       Current state of node (NOT CURRENTLY USED)
#+ @param p_content     Content for this node
#+
#+ @code
#+ define  o_parent, o_child om.DomNode
#+ let o_child = o_parent.createChild("Node")
#+ call Node_Set(o_child, p_id, p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)
#
public function Node_Set(o_node om.DomNode, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)

  if o_node is not NULL
  then
    call o_node.setAttribute("id", p_id)
    call o_node.setAttribute("key", p_key)
    call o_node.setAttribute("text", p_text)
    call o_node.setAttribute("image", p_image) 
    call o_node.setAttribute("iconOpen", p_iconOpen)
    call o_node.setAttribute("iconClosed", p_iconClosed)
    call o_node.setAttribute("state", p_state)
    call o_node.setAttribute("content", p_content)
  end if
  
end function


#
#! XML
#+ Get XML string from document
#+
#+ @param r_tree    TreeCordion instance
#+
#+ @returnType string
#+ return XML string of TreeCordion's DOM tree
#+
#+ @code
#+ define p_xml string,
#+   r_acc tTreeCordion
#+ let p_xml = wc_treecordion.XML(r_acc.*)
#
public function XML(r_tree tTreeCordion) returns string
  return r_tree.dom.toString()
end function



#
# PRIVATE functions
#


#
#! id_New
#+ Generate or return the next Item ID
# Prob should check if ID has been used before
# if option to force new id, then go to next id
#
#+ @param p_id    Item ID, 0 if allocate next ID in sequence
#+
#+ @returnType string
#+ @return Item ID
#

private function id_New(p_id string) returns string

  if (p_id.getLength() < 1)
  then
    let m_lastId = m_lastId + 1
    let p_id = m_lastId
  end if
  
  return p_id
  
end function