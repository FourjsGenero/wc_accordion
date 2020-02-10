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
# CLASS METHODS
#

#
#! Init
#+ Initialize the module
#+
#+ @code
#+ call wc_accordion.Init()
#
public function Init()

end function




#
# OBJECT METHODS
#

#
#! tAccordion::Serialize
#+ Serialize an accordion structure
#+
#+ @returnType string
#+ @return JSON string of accordion structure
#+
#+ @code
#+ define r_acc tAccordion,
#+   p_json string
#+ let p_json = r_acc.Serialize()
#
public function (this tAccordion) Serialize() returns string
  
  return util.JSON.stringify(this)
  
end function


