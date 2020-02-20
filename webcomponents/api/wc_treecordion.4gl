#
# wc_treecordion  TreeCordion webcomponent API
#
# CLASS Methods
#
#   Init         Initialize
#   Create       Create an instance of tTree
#   Node_Add     Attach Item as a child node to a parent node
#
# OBJECT Methods
#
# tTree::
#   Clear        Clear tTree record
#   Set          Set Tree from parameters
#   Init         Initialize contents of widget
#   Show         Show or hide a node
#   IsVisible    Is contents of node visible?
#   Expand       Expand node, default is root node (all)
#   Collapse     Collapse node, default is root node (all)
#   Node         Returns the om.DomNode by ID
#   XML          Get XML string from document
#
#   Item_Add     Add a child Item to a parent Item
#   Item_Attach  Attach an Item to a parent Item
#   Item_Delete  Delete an Item and its descendents by ID
#   Item_Get     Get an Item by ID
#   Item_Update  Update attributes of an Item
#
# tItem::
#   Set          Set Item from parameters
#   Attach       Attach Item as a child node to a parent node
#   Update       Set node attributes from Item
#

import util

#
# Type Defs
#
public type
  -- TreeCordian data structure
  tTree record
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
    state string,         # State of Item
    content string        # HTML content
  end record

# Module
private
  define
    m_lastId integer






#
# CLASS METHODS ----------------------------------
#    

#
#! Init
#+ Initialize the module
#+
#+ @code
#+ call wc_treecordion.Init()
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
#+ define r_tree wc_treecordion.tTree
#+ let r_tree = wc_treecordion.Create("formonly.p_treecordion")
#
public function Create(p_field string) 
  returns tTree

  define
    r_tree tTree

  let r_tree.field = p_field
  let r_tree.doc = om.DomDocument.create("TreeCordion")
  let r_tree.dom = r_tree.doc.getDocumentElement()
  let r_tree.Id_New = function id_New   # Default internal

  return r_tree.*
  
end function


#
#! Node_Add
#+ Attach Item as a child node to a parent node
#+
#+ @param o_parent       Parent DOM node
#+ @param p_id           Item ID
#+ @param p_key          Alternate key
#+ @param p_text         Text attribute
#+ @param p_image        Image attribute
#+ @param p_iconOpen     Icon for Open state
#+ @param p_iconClosed   Icon for Closed state
#+ @param p_state        State of node
#+ @param p_content      Content for this node
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ define a_nodes dynamic array of om.DomNode, r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem
#+ let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], r_tree.id, "999", "", "Section 999", "Memory-16.png", "", "", "closed", "This is an new for <B>999</B> section")
#
public function Node_Add(o_parent om.DomNode, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)
  returns om.DomNode

  define
    r_item tItem

  call r_item.Set(p_id,  p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)

  return r_item.Attach(o_parent)
  
end function



#
# tTree OBJECT METHODS -----------------------------
#

#
#! tTree::Clear
#+ Clear record: reset attributes on root node, and delete all children
#+
#+ @code
#+ define r_tree wc_treecordion.tTree
#+ call r_tree.Clear()
#
public function (this tTree) Clear()

  -- reset attributes on root node, and delete all children
  if this.dom is not NULL
  then
    call this.dom.removeChild(this.dom)
    let this.dom = this.doc.getDocumentElement()
  end if
  
end function



#
#! tTree::Set
#+ Set tTree from parameters
#
#+ @param p_id                    Currently selected node ID
#+ @param p_field string          Form field name
#+ @param p_title string          Title text
#+ @param p_narrative string      Narrative or description
#+ @param p_imagePath string      Local file or URL image prefix
#+ @param p_iconOpen string       Default ui-icon for open state
#+ @param p_iconClosed string     Default ui-icon for closed state
#+ @param po_doc om.DomDocument   DOM document
#+ @param po_dom om.DomNode       Root DomNode of DOM document
#+ @param pf_func                 Refers to function(p_id string) returns string
#+
#+ @code
#+ define r_tree wc_treecordion.tTree
#+ call r_tree.Set(r_tree.id, "999", "", "Section 999", "Memory-16.png", "", "", "closed", "This is an new for <B>999</B> section")
#
public function (this tTree) Set (p_id string, p_field string, p_title string, p_narrative string, p_imagePath string, p_iconOpen string, p_iconClosed string, po_doc om.DomDocument, po_dom om.DomNode, pf_func function(p_id string) returns string)

  let this.id = p_id
  let this.field = p_field
  let this.title = p_title
  let this.narrative = p_narrative
  let this.imagePath = p_imagePath
  let this.iconOpen = p_iconOpen
  let this.iconClosed = p_iconClosed
  let this.doc = po_doc
  let this.dom = po_dom
  let this.Id_New = pf_func

end function


#
#! tTree::Init
#+ Initialize contents of widget
#+
#+ @code
#+ define r_tree wc_treecordion.tTree
#+ let r_tree.title = "Title"
#+ ...
#+ before input
#+   call r_tree.Init()
#
public function (this tTree) Init()

  call this.dom.setAttribute("title", this.title)
  call this.dom.setAttribute("narrative", this.narrative)
  call this.dom.setAttribute("imagePath", this.imagePath)
  call this.dom.setAttribute("iconClosed", this.iconClosed)
  call this.dom.setAttribute("iconOpen", this.iconOpen)
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Set", this.XML()], [])
  
end function


#
#! tTree::Show
#+ Show or hide a node
#+
#+ @param p_id      Node ID
#+ @param p_show    TRUE to show, else hide
#+
#+ @code
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem
#+ call r_tree.Show(r_item.id, TRUE)
#
public function (this tTree) Show(p_id string, p_show boolean)
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Show", p_id, p_show], [])
end function


#
#! tTree::IsVisible
#+ Is contents of node visible?
#+
#+ @param p_id      Node ID
#+
#+ @returnType boolean
#+ @return TRUE if visible, else FALSE
#+
#+ @code
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem
#+ if r_tree.IsVisible(r_item.id)
#+ then
#+   message "contents of item ", r_item.id, " is visible"
#+ end if
#
public function (this tTree) IsVisible(p_id string)
  returns (boolean)

  define
    p_visible boolean
    
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "IsVisible", p_id], [p_visible])

  return p_visible
end function


#
#! tTree::Expand
#+ Expand node, default is root node (all)
#+
#+ @param p_id      Node ID
#+
#+ @code
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem
#+ call r_tree.Expand(r_item.id)
#
public function (this tTree) Expand(p_id string)
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Expand", p_id], [])
end function


#
#! tTree::Collapse
#+ Collapse node, default is root node (all)
#+
#+ @param p_id      Node ID
#+
#+ @code
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem
#+ call r_tree.Collapse(r_item.id)
#
public function (this tTree) Collapse(p_id string)
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Collapse", p_id], [])
end function


#
#! tTree::Node
#+ Returns the om.DomNode by ID
#+
#+ @param p_id          Item ID
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem, o_node om.DomNode
#+ let o_node = r_tree.Node(r_item.id)
#
public function (this tTree) Node(p_id string)
  returns (om.DomNode)

  define
    ol_nodes om.NodeList

  if p_id.getLength()
  then
    let ol_nodes = this.dom.selectByPath("//Node[@id='" || p_id || "']")
    if ol_nodes.getLength()
    then
      -- return just the first node
      return ol_nodes.item(1)
    end if
  end if

  return NULL
  
end function


#
#! tTree::XML
#+ Get XML string from document
#+
#+ @returnType string
#+ return XML string of TreeCordion's DOM tree
#+
#+ @code
#+ define p_xml string,
#+   r_tree wc_treecordion.tTree
#+ let p_xml = r_tree.XML()
#
public function (this tTree) XML()
  returns string
  return this.dom.toString()
end function


#
#! tTree::Item_Add
#+ Add a child Item to a parent Item
#+
#+ @param p_parentId   Parent Item ID
#+ @param p_id           Item ID
#+ @param p_key          Alternate key
#+ @param p_text         Text attribute
#+ @param p_image        Image attribute
#+ @param p_iconOpen     Icon for Open state
#+ @param p_iconClosed   Icon for Closed state
#+ @param p_state        Initial state of node (NOT CURRENTLY USED)
#+ @param p_content      Content for this node
#+
#+ @returnType string
#+ @return ID of node added
#+
#+ @code
#+ define  r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem, p_parentId, p_newID integer
#+ ...
#+ let p_newID = r_tree.Item_Add(p_parentId, p_id, "", "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
#
public function (this tTree) Item_Add(p_parentID string, p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)
  returns (string)

  define
    r_item tItem

  -- Set Item record, use Tree default icons if not defined
  call r_item.Set(p_id, p_key, p_text, p_image, NVL(p_iconOpen, this.iconOpen), NVL(p_iconClosed, this.iconClosed), p_state, p_content)
  return this.Item_Attach(p_parentID, r_item)

end function


#
#! tTree::Item_Attach
#+ Add a child Item to a parent Item
#+
#+ @param p_parentId   Parent Item ID
#+ @param r_item       Item record
#+
#+ @returnType string
#+ @return ID of node added
#+
#+ @code
#+ define  r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem, p_parentId, p_newID integer
#+ ...
#+ let p_newID = r_tree.Item_Add(p_parentId, r_item)
#
public function (this tTree) Item_Attach(p_parentID string, r_item tItem)
  returns (string)

  define
    o_parent om.DomNode,
    o_item om.DomNode

  -- Find the parent node by ID
  let o_parent = this.Node(p_parentId)
  if o_parent is NULL
  then
    let o_parent = this.dom
  end if

  if p_parentID = r_item.id
  then
    let r_item.id = NULL
  end if
  
  -- New ID?
  let r_item.id = this.Id_New(r_item.id)

  -- Parent and child can't have the same ID
  if p_parentId = r_item.id
  then
    return ""
  end if

  -- Check if Id has been used before
  if this.Node(r_item.id) is not NULL
  then
    return ""
  end if
  
  -- Add the Node
  #%%%REC let o_item = Node_Add(o_parent, p_id, p_key, p_text, p_image, p_iconOpen, p_iconClosed, p_state, p_content)
  let o_item = r_item.Attach(o_parent)
  
  -- Refresh the New Item in Widget
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Item_Add",
    p_parentId,
    r_item.id,
    r_item.text,
    r_item.image,
    r_item.iconOpen,
    r_item.iconClosed,
    r_item.state,
    r_item.content],
    [])

  return r_item.id
  
end function


#
#! tTree::Item_Delete
#+ Delete an Item and its descendents by ID
#+
#+ @param p_id          Item ID
#+
#+ @code
#+ define  r_tree wc_treecordion.tTreeCordion, r_item wc_treecordion.tItem, p_currentID integer
#+ let p_currentID = r_tree.Item_Delete(r_item.id)
#
public function (this tTree) Item_Delete(p_id string)
  returns string

  define
    o_item om.DomNode,
    o_parent om.DomNode,
    o_next om.DomNode
    
    
  -- Find the parent node by ID
  let o_item = this.Node(p_id)
  if o_item is NULL
  then
    return NULL
  end if
  let o_parent = o_item.getParent()

  -- Refresh to remove Item form Widget
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Item_Delete", p_id], [])

  -- Find the next "current" node once item has been deleted
  -- Try previous sib, next sib, otherwise parent
  let o_next = NVL(NVL(o_item.getPrevious(), o_item.getNext()), o_parent)

  -- Remove the Node
  call o_parent.removeChild(o_item)

  -- Return what should be the next current id
  return o_next.getAttribute("id")
  
end function


#
#! tTree::Item_Get
#+ Get an Item by ID
#+
#+ @param p_id          Item ID
#+
#+ @returnType tItem
#+ @return Record of the item node
#+
#+ @code
#+ define  r_tree wc_treecordion.tTree,r_iem wc_treecordion.tItem, p_id integer
#+ let r_item = r_tree.Item_Get(p_id)
#
public function (this tTree) Item_Get(p_id string) 
  returns (tItem)

  define
    r_item tItem,
    o_item om.DomNode

  -- Get node
  let o_item = this.Node(p_id)

  -- Extract all the attributes
  if (o_item is not NULL)
  then
    let r_item.id = o_item.getAttribute("id")
    let r_item.key = o_item.getAttribute("key")
    let r_item.text = o_item.getAttribute("text")
    let r_item.image = o_item.getAttribute("image")
    let r_item.iconOpen = o_item.getAttribute("iconOpen")
    let r_item.iconClosed = o_item.getAttribute("iconClosed")
    let r_item.state = iif(this.IsVisible(p_id), 'open', 'closed')
    let r_item.content = o_item.getAttribute("content")
  end if
  
  return r_item
  
end function


#
#! tTree::Item_Update
#+ Update attributes of an Item
#+
#+ @param r_item       Item record
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ 
#+ define r_tree wc_treecordion.tTree, r_item wc_treecordion.tItem, p_id integer
#+ ...
#+ call r_tree.Item_Update(r_item)
#
public function (this tTree) Item_Update(r_item tItem)

  define
    o_item om.DomNode

  -- Find the node by ID
  let o_item = this.Node(r_item.id)
  if o_item is NULL
  then
    return
  end if

  -- Set attributes of Node
  call r_item.Update(o_item)
  
  -- Refresh the Item in Widget
  call ui.Interface.frontCall("webcomponent", "call", [this.field, "Item_Set", r_item.*], [])
  
end function







#
# tItem::Methods
#


#
#! tItem::Set
#+ Set Item from parameters
#+
#+ @param  p_id           Item ID
#+ @param  p_key          Alternate key
#+ @param  p_text         Text attribute
#+ @param  p_image        Image attribute
#+ @param  p_iconOpen     Icon for Open state
#+ @param  p_iconClosed   Icon for Closed state
#+ @param  p_state        Initial state of node (NOT CURRENTLY USED)
#+ @param  p_content      Content for this node
#+
#+ @code
#+ define   r_item wc_treecordion.tItem
#+ call r_item.Set(r_tree.id, "999", "", "Section 999", "Memory-16.png", "", "", "closed", "This is an new for <B>999</B> section")
#
public function (this tItem) Set(p_id string, p_key string, p_text string, p_image string, p_iconOpen string, p_iconClosed string, p_state string, p_content string)

  let this.id = p_id
  let this.key = p_key
  let this.text = p_text
  let this.image = p_image
  let this.iconOpen = p_iconOpen
  let this.iconClosed = p_iconClosed
  let this.state = p_state
  let this.content = p_content

end function


#
#! tItem::Attach
#+ Attach Item as a child node to a parent node
#+
#+ @param o_parent      Parent DOM node
#+
#+ @returnType om.DomNode
#+ @return DOM node of added child
#+
#+ @code
#+ define a_nodes dynamic array of om.DomNode, r_item wc_treecordion.tItem
#+ let a_nodes[p_depth] = r_item.Attach(a_nodes[p_depth-1])
#
public function (this tItem) Attach(o_parent om.DomNode)
  returns om.DomNode

  define
    o_child om.DomNode

  let o_child = o_parent.createChild("Node")
  call this.Update(o_child)

  return o_child
  
end function


#
#! tItem::Update
#+ Update node attributes from Item
#+
#+ @param o_node        DOM node
#+
#+ @code
#+ define  o_parent, o_child om.DomNode, r_item wc_treecordion.tItem
#+ let o_child = o_parent.createChild("Node")
#+ ...
#+ call r_item.Update(o_child)
#
public function (this tItem) Update(o_node om.DomNode)

  if o_node is not NULL
  then
    call o_node.setAttribute("id", this.id)
    call o_node.setAttribute("key", this.key)
    call o_node.setAttribute("text", this.text)
    call o_node.setAttribute("image", this.image)
    call o_node.setAttribute("iconOpen", this.iconOpen)
    call o_node.setAttribute("iconClosed", this.iconClosed)
    call o_node.setAttribute("state", this.state)
    call o_node.setAttribute("content", this.content)
  end if
  
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