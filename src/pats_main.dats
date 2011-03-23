(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: March, 2011
//
(* ****** ****** *)

staload "libc/SATS/stdio.sats"

(* ****** ****** *)

staload "pats_location.sats"
staload "pats_lexing.sats"
staload "pats_tokbuf.sats"
staload "pats_syntax.sats"
staload "pats_parsing.sats"

(* ****** ****** *)
//
dynload "pats_utils.dats"
//
dynload "pats_symbol.dats"
dynload "pats_filename.dats"
dynload "pats_location.dats"
//
(* ****** ****** *)

dynload "pats_reader.dats"
dynload "pats_lexbuf.dats"
dynload "pats_lexing_token.dats"
dynload "pats_lexing_print.dats"
dynload "pats_lexing_error.dats"
dynload "pats_lexing.dats"
dynload "pats_tokbuf.dats"

dynload "pats_syntax_print.dats"
dynload "pats_syntax.dats"

dynload "pats_parsing_util.dats"
dynload "pats_parsing_error.dats"
dynload "pats_parsing_misc.dats"
dynload "pats_parsing_e0xp.dats"

(* ****** ****** *)

implement
main (
  argc, argv
) = () where {
//
  val () = println! ("Hello from ATS/Postiats!")
//
  var buf: tokbuf
  val () = tokbuf_initialize_getc (buf, lam () =<cloptr1> getchar ())
  var err: int = 0
  val e0xp = p_e0xp (buf, 0, err)
//
  val () = if (err = 0) then fprint_e0xp (stdout_ref, e0xp)
  val () = if (err = 0) then print_newline ()
//
  val () = tokbuf_uninitialize (buf)
//
  val () = fprint_the_lexerrlst (stdout_ref)
  val () = fprint_the_parerrlst (stdout_ref)
//
} // end of [main]

(* ****** ****** *)

(* end of [pats_main.dats] *)
