<?php
/*
**
** The PHP code is generated by atscc2php
** The starting compilation time is: 2016-12-19:  0h:23m
**
*/

function
ats2phppre_option_some($arg0)
{
//
  $tmpret0 = NULL;
//
  __patsflab_option_some:
  $tmpret0 = array($arg0);
  return $tmpret0;
} // end-of-function


function
ats2phppre_option_none()
{
//
  $tmpret1 = NULL;
//
  __patsflab_option_none:
  $tmpret1 = NULL;
  return $tmpret1;
} // end-of-function


function
ats2phppre_option_unsome($arg0)
{
//
  $tmpret2 = NULL;
  $tmp3 = NULL;
//
  __patsflab_option_unsome:
  $tmp3 = $arg0[0];
  $tmpret2 = $tmp3;
  return $tmpret2;
} // end-of-function


function
ats2phppre_option_is_some($arg0)
{
//
  $tmpret4 = NULL;
//
  __patsflab_option_is_some:
  // ATScaseofseq_beg
  do {
    // ATSbranchseq_beg
    __atstmplab0:
    if(ATSCKptrisnull($arg0)) goto __atstmplab3;
    __atstmplab1:
    $tmpret4 = true;
    break;
    // ATSbranchseq_end
    // ATSbranchseq_beg
    __atstmplab2:
    __atstmplab3:
    $tmpret4 = false;
    break;
    // ATSbranchseq_end
  } while(0);
  // ATScaseofseq_end
  return $tmpret4;
} // end-of-function


function
ats2phppre_option_is_none($arg0)
{
//
  $tmpret5 = NULL;
//
  __patsflab_option_is_none:
  // ATScaseofseq_beg
  do {
    // ATSbranchseq_beg
    __atstmplab4:
    if(ATSCKptriscons($arg0)) goto __atstmplab7;
    __atstmplab5:
    $tmpret5 = true;
    break;
    // ATSbranchseq_end
    // ATSbranchseq_beg
    __atstmplab6:
    __atstmplab7:
    $tmpret5 = false;
    break;
    // ATSbranchseq_end
  } while(0);
  // ATScaseofseq_end
  return $tmpret5;
} // end-of-function

/* ****** ****** */

/* end-of-compilation-unit */
?>