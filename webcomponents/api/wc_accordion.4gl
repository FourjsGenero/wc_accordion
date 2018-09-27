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
    title string,
    narrative string,
    sections dynamic array of tSection
  end record


#
#! Init
#+ Initialize
#+
#+ @code
#+ call wc_accordion.Init()
#
public function Init()

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


