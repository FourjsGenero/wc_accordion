#
# main.4gl  Main for all unit tests
#

import FGL fgldialog
import FGL test_accordion
import FGL test_jqaccordion
import FGL test_treecordion

private define
 m_menu boolean


#
# Main: Unit Test
#

main

  define
    p_test string

  let p_test = NVL(ARG_VAL(1), "MENU")
  call Run(p_test)
  
end main


#
#! Setup
#
private function Setup()

  if not m_menu
  then
    close window screen
  end if
  
end function


#
#! Teardown
#
private function Teardown()
end function


#
#! Menu
#
private function Menu()

  let m_menu = TRUE
  
  menu "Menu"
    on action accordion attribute(text="Accordion")
      call Run("Accordion")
    on action jqaccordian attribute(text="jQuery Accordion")
      call Run("jqAccordion")
    on action treecordion_node attribute(text="TreeCordion by Node")
      call Run("TreeCordion-node")
    on action treecordion_item attribute(text="TreeCordion by Item")
      call Run("TreeCordion-item")
    on action close
      exit menu
  end menu
end function


#
#! Run
#
public function Run(p_request)

  define
    p_request string

  case p_request
    when "Accordion"
      call test_accordion.Test()
    when "jqAccordion"
      call test_jqaccordion.Test()
    when "TreeCordion-node"
      call test_treecordion.Test("node")
    when "TreeCordion-item"
      call test_treecordion.Test("item")
    when "MENU"
      call Menu()
  end case
    
end function


