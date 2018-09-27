#
# test_accordion.4gl  Unit tests for wc_accordion
#

import FGL fgldialog
import FGL wc_accordion




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
#! Test_Accordion
#
public function Test()

  define
    r_acc wc_accordion.tAccordion,
    p_accordion string


  call Setup()

  -- Load some content
  --% Set from form file properties, otherwise can override here
  #let r_acc.title = "Accordion Test"
  #let r_acc.narrative = "This is a test for an accordion widget"
  call Load(r_acc.sections, 1)
  let p_accordion = wc_accordion.Serialize(r_acc.*)
  
  -- Interact
  open window w_test with form "test_accordion"
  input by name p_accordion without defaults
  close window w_test

  call Teardown()
  
end function



#
#! Accordian_Load
#

public function Load(a_sections dynamic array of wc_accordion.tSection, p_set integer)

  case p_set
    when 1
      let a_sections[1].name = "Section A"
      let a_sections[1].content = "This is content for <B>A</B> section"
      let a_sections[2].name = "Section B"
      let a_sections[2].content = "This is content for <B>B</B> section"
      let a_sections[3].name = "Section C"
      let a_sections[3].content = "This is content for <B>C</B> section"
      let a_sections[4].name = "Section D"
      let a_sections[4].content = "This is content for <B>D</B> section"
      let a_sections[5].name = "Section E"
      let a_sections[5].content = "This is content for <B>E</B> section"
    when 2
      let a_sections[1].name = "Section F"
      let a_sections[1].content = "This is content for <B>F</B> section"
      let a_sections[2].name = "Section G"
      let a_sections[2].content = "This is content for <B>G</B> section"
      let a_sections[3].name = "Section H"
      let a_sections[3].content = "This is content for <B>H</B> section"
      let a_sections[4].name = "Section I"
      let a_sections[4].content = "This is content for <B>I</B> section"
      let a_sections[5].name = "Section J"
      let a_sections[5].content = "This is content for <B>J</B> section"
  end case
end function



