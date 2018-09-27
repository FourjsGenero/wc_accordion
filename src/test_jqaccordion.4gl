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
  let p_jqaccordion = wc_jqaccordion.Serialize(r_acc.*)
  
  -- Interact
  open window w_test with form "test_jqaccordion"
  input by name p_jqaccordion attributes(unbuffered, without defaults)
    on action collapsible attribute(text="Collapsible")
      call wc_jqaccordion.Collapsible(r_acc.*, TRUE)
    on action not_collapsible attribute(text="Not Collapsible")
      call wc_jqaccordion.Collapsible(r_acc.*, FALSE)
    on action icons attribute(text="Icons")
      call wc_jqaccordion.Icons(r_acc.*, "ui-icon-arrow-1-s", "ui-icon-arrow-1-n")
    on action one_icon attribute(text="One Icon")
      call wc_jqaccordion.Icons(r_acc.*, "ui-icon-mail-closed", "")
    on action no_icons attribute(text="No Icons")
      call wc_jqaccordion.Icons(r_acc.*, "", "")
    on action data1 attribute(text="Load Set 1")
      call test_accordion.Load(r_acc.sections, 1)
      let p_jqaccordion = wc_jqaccordion.Serialize(r_acc.*)
    on action data2 attribute(text="Load Set 2")
      call test_accordion.Load(r_acc.sections, 2)
      let p_jqaccordion = wc_jqaccordion.Serialize(r_acc.*)
  end input
  close window w_test

  call Teardown()
  
end function




