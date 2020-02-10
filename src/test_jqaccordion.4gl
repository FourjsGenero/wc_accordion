#
# test_accordion.4gl  Unit tests for wc_accordion
#

import FGL fgldialog
import FGL wc_accordion
import FGL test_accordion
import FGL wc_jqaccordion




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
public function Test()

  define
    r_acc wc_jqaccordion.tAccordion,
    p_jqaccordion string


  call Setup()
  call wc_jqaccordion.Create("formonly.p_jqaccordion")
    returning r_acc.*


  -- Load some content
  let r_acc.title = "jqAccordion Test"
  let r_acc.narrative = "This is a test for a jqAccordion widget"
  call test_accordion.Load(r_acc.sections, 1)
  let p_jqaccordion = r_acc.Serialize()
  
  -- Interact
  open window w_test with form "test_jqaccordion"
  input by name p_jqaccordion attributes(unbuffered, without defaults)
    on action collapsible attribute(text="Collapsible")
      call r_acc.Collapsible(TRUE)
    on action not_collapsible attribute(text="Not Collapsible")
      call r_acc.Collapsible(FALSE)
    on action icons attribute(text="Icons")
      call r_acc.Icons("ui-icon-arrow-1-s", "ui-icon-arrow-1-n")
    on action one_icon attribute(text="One Icon")
      call r_acc.Icons("ui-icon-mail-closed", "")
    on action no_icons attribute(text="No Icons")
      call r_acc.Icons("", "")
    on action data1 attribute(text="Load Set 1")
      call test_accordion.Load(r_acc.sections, 1)
      let p_jqaccordion = r_acc.Serialize()
    on action data2 attribute(text="Load Set 2")
      call test_accordion.Load(r_acc.sections, 2)
      let p_jqaccordion = r_acc.Serialize()
  end input
  close window w_test

  call Teardown()
  
end function




