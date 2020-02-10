#
# test_accordion.4gl  Unit tests for wc_accordion
#

import FGL fgldialog
import FGL wc_treecordion




#
#! Setup
#
private function Setup()  
end function


#
#! Teardown
#
private function Teardown()
end function



#
#! Test
#
public function Test(p_loadMethod string)

  define
    r_tree wc_treecordion.tTree,
    r_item wc_treecordion.tItem,
    r_clip wc_treecordion.tItem


  call Setup()

  -- Initialize
  call wc_treecordion.Create("formonly.p_treecordion") returning r_tree.*
  let r_tree.title = "TreeCordion Test"
  let r_tree.narrative = "This is a test for an Accordion Tree widget"
  let r_tree.imagePath = "images"
  let r_tree.iconClosed = "ui-icon-triangle-1-e"
  let r_tree.iconOpen = "ui-icon-triangle-1-s"

  
  -- Open
  open window w_test with form "test_treecordion"
  let r_tree.id = "1"
  
  -- Load some content
  if p_loadMethod.toUpperCase() = "NODE"
  then
    call Node_Load(r_tree.dom)
  else
    call Item_Load(r_tree.*)
  end if
  
  -- Interact
  input r_tree.id, r_item.*
    from p_treecordion, item.*
    attributes(unbuffered, without defaults)
    
    before input
      call r_tree.Init()
      let r_item = r_tree.Item_Get(r_tree.id)
      
    on change p_treecordion
      let r_item = r_tree.Item_Get(r_tree.id)
      
    on action show attribute(text="Show")
      call r_tree.Show(r_tree.id, TRUE)
    on action hide attribute(text="Hide")
      call r_tree.Show(r_tree.id, FALSE)
      
    on action expand attribute(text="Expand")
      call r_tree.Expand(r_tree.id)
    on action expandall attribute(text="Expand All")
      call r_tree.Expand("")
      
    on action collapse attribute(text="Collapse")
      call r_tree.Collapse(r_tree.id)
    on action collapseall attribute(text="Collapse All")
      call r_tree.Collapse("")
      
    on action select attribute(defaultview=NO)
      let r_item = r_tree.Item_Get(r_tree.id)
        
    on action set2
      let r_tree.id = "2"
      let r_item = r_tree.Item_Get(r_tree.id)
    on action set3
      let r_tree.id = "3"
      let r_item = r_tree.Item_Get(r_tree.id)
        
    on action visible attribute(text="Is Visible?")
      if r_tree.IsVisible(r_tree.id)
      then
        message "Visible"
      else
        message "Hidden"
      end if

    on action add attribute(text="Add")
      let r_tree.id = r_tree.Item_Add(r_tree.id, r_item.*)
      #%eg call wc_treecordion.Item_Add(r_tree.*, r_tree.id, "999", "", "Section 999", "Memory-16.png", "", "", "closed", "This is an new for <B>999</B> section")
    on action update attribute(text="Update")
      call r_tree.Item_Update(r_item)
      #%eg call wc_treecordion.Item_Update(r_tree.*, r_item.id, "", "Section Z", "InternalDrive-16.png", "ui-icon-folder-open", "ui-icon-folder-collapsed", "closed", "This is an update for <B>Z</B> section")
    on action delete attribute(text="Delete")
      let r_tree.id = r_tree.Item_Delete(r_item.id)
      let r_item = r_tree.Item_Get(r_tree.id)

    on action copy
      let r_clip = r_item
      message "copied"
    on action paste
      let r_item = r_clip
      let r_item.id = ""
      message "pasted"
      
    on action close
      exit input
  end input

  -- Close
  close window w_test
  call Teardown()
  
end function


#
#! Node_Load
#+ Load content into TreeCordion by Node
#
function Node_Load(d_root om.DomNode)

  define
    a_nodes dynamic array of om.DomNode,
    p_depth integer,    
    p_id integer

  -- Load some content  
  let p_id = 1000
  let p_depth = 1
  let a_nodes[1] = d_root
  let p_depth = 2
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
  let p_depth = 2
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Section B", "Chip1-16.png", "", "", "closed", "<B><li>Item 1</li><li>Item 2</li><li>Item 3</li></B>")
  let p_depth = 3
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 1", "Dashboard-16.png", "", "", "closed", "This is content for chapter <B>1</B>")
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 2", "DatabaseActive-16.png", "", "", "closed", "This is content for chapter <B>2</B>")
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 3", "HardDisk-16.png", "", "", "closed", "This is content for chapter <B>3</B>")
  let p_depth = 2
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Section C", "InternalDrive-16.png", "", "", "closed", "This is content for <B>C</B> section")
  let p_depth = 3
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 1", "Memory-16.png", "", "", "closed", "This is content for chapter <B>1</B><table>
 <tr>
  <td>Col1<td/>
  <td>Col2<td/>
  <td>Col3<td/>
 </tr>
 <tr>
  <td>A1<td/>
  <td>B1<td/>
  <td>C1<td/>
 </tr>
 <tr>
  <td>A2<td/>
  <td>B2<td/>
  <td>C2<td/>
 </tr>
 <tr>
  <td>A3<td/>
  <td>B3<td/>
  <td>C3<td/>
 </tr>
</table>
")
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 2", "network-green-16.png", "", "", "closed", "This is content for chapter <B>2</B>")
  let a_nodes[p_depth] = wc_treecordion.Node_Add(a_nodes[p_depth-1], p_id:=p_id+1, "", "Chapter 3", "network-orange-16.png", "", "", "closed", 'This is content for chapter <B>3</B> which contains an image<img src="http://4js.com/wp-content/uploads/2015/05/logo_4Js_2014_CMYK_seul-300x92.png"/>')
    
end function


#
#! Item_Load
#+ Load content into TreeCordion by Item
#
function Item_Load(r_tree tTree)

  define
    --r_acc wc_treecordion.tTreeCordion,
    a_items dynamic array of string,
    p_depth integer,    
    p_id integer

  -- Load some content  
  let p_id = 0
  let p_depth = 1
  let a_items[1] = NULL
  let p_depth = 2
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Section A", "ActivityMonitor-16.png", "", "", "closed", "This is content for <B>A</B> section")
  let p_depth = 2
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Section B", "Chip1-16.png", "", "", "closed", "<B><li>Item 1</li><li>Item 2</li><li>Item 3</li></B>")
  let p_depth = 3
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 1", "Dashboard-16.png", "", "", "closed", "This is content for chapter <B>1</B>")
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 2", "DatabaseActive-16.png", "", "", "closed", "This is content for chapter <B>2</B>")
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 3", "HardDisk-16.png", "", "", "closed", "This is content for chapter <B>3</B>")
  let p_depth = 2
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Section C", "InternalDrive-16.png", "", "", "closed", "This is content for <B>C</B> section")
  let p_depth = 3
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 1", "Memory-16.png", "", "", "closed", "This is content for chapter <B>1</B><table>
 <tr>
  <td>Col1<td/>
  <td>Col2<td/>
  <td>Col3<td/>
 </tr>
 <tr>
  <td>A1<td/>
  <td>B1<td/>
  <td>C1<td/>
 </tr>
 <tr>
  <td>A2<td/>
  <td>B2<td/>
  <td>C2<td/>
 </tr>
 <tr>
  <td>A3<td/>
  <td>B3<td/>
  <td>C3<td/>
 </tr>
</table>
")
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 2", "network-green-16.png", "", "", "closed", "This is content for chapter <B>2</B>")
  let a_items[p_depth] = r_tree.Item_Add(a_items[p_depth-1], "", "", "Chapter 3", "network-orange-16.png", "", "", "closed", 'This is content for chapter <B>3</B> which contains an image<img src="http://4js.com/wp-content/uploads/2015/05/logo_4Js_2014_CMYK_seul-300x92.png"/>')
    
end function