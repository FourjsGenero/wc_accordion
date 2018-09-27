import util

#
# Accordion Type Def
#
public type
  tSection record
    name string,
    content string
  end record,
  tAccordion record
    field string,
    title string,
    narrative string,
    sections dynamic array of tSection
  end record


#
#! Init
#+ Initialize
#+
#+ @code
#+ call wc_jqaccordion.Init()
#
public function Init()

end function



#
#! Create
#+ Creates a new instance of jqAccordion
#+
#+ @param p_field     Form name of the field
#+ @returnType        tAccordion
#+ @return            Accordion record
#+
#+ @code
#+ define r_acc wc_jqaccordion.tAccordion
#+ call wc_jqaccordion.Create("formonly.p_jqaccordion") returning r_acc.*
#
public function Create(p_field string) returns tAccordion

  define
    r_acc tAccordion

  let r_acc.field = p_field

  return r_acc.*
  
end function


#
#! Collapsible
#+ Set whether the accordion is independently collapsible or not
#+
#+ @param p_collapse    Collapsible if TRUE
#+
#+ @code
#+ call wc_jqaccordion.Collapsible(TRUE)
#

public function Collapsible(r_acc tAccordion, p_collapse boolean)

  call ui.Interface.frontCall("webcomponent", "call", [r_acc.field, "Collapsible", p_collapse], [])

end function


#
#! Icons
#+ Set icons for open and closed states
#+ See https://api.jqueryui.com/resources/icons-list.html
#+
#+ @param r_acc       tAccordion record
#+ @param p_closed    Name of JQuery-UI icon for closed state
#+ @param p_open      Name of JQuery-UI icon for open state
#+
#+ @code
#+ define r_acc tAccordion
#+ ...
#+ call wc_jqaccordion.Icons(r_acc.*, "ui-icon-folder-open", "ui-icon-folder-collapsed")
#

public function Icons(r_acc tAccordion, p_closed string, p_open string)

  call ui.Interface.frontCall("webcomponent", "call", [r_acc.field, "Icons", p_closed, p_open], [])

end function


#
#! Serialize
#+ Serialize an accordion structure
#+
#+ @param r_accordion   Accordion instance
#+
#+ @returnType string
#+ @return JSON string of accordion structure
#+
#+ @code
#+ define r_acc tAccordion,
#+   p_json string
#+ let p_json = wc_jqaccordion.Serialize(r_acc.*)
#
public function Serialize(r_accordion tAccordion) returns string
  
  return util.JSON.stringify(r_accordion)
  
end function

