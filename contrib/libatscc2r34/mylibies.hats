(*
** For writing ATS code
** that translates into R(stat)
*)

(* ****** ****** *)
//
// HX-2014-09-09
//
(* ****** ****** *)
//
#staload "./basics_r34.sats"
(*
#staload _ = "./DATS/basics.dats"
*)
//
(* ****** ****** *)
//
#staload "./SATS/integer.sats"
//
(* ****** ****** *)
//
#staload "./SATS/bool.sats"
#staload "./SATS/float.sats"
#staload "./SATS/string.sats"
//
(* ****** ****** *)
//
#staload "./SATS/print.sats" // HX: printing to the console
//
(* ****** ****** *)

#staload "./SATS/intrange.sats"

(* ****** ****** *)
//
#staload "./SATS/R34vector.sats"
#staload _ = "./DATS/R34vector.dats"
//
(* ****** ****** *)
//
#staload "./SATS/R34dframe.sats"
#staload _ = "./DATS/R34dframe.dats"
//
(* ****** ****** *)
//
#staload
"./SATS/ML/list0.sats" // un-indexed list
#staload
_(*anon*) = "./DATS/ML/list0.dats" // un-indexed list
//
#staload
"./SATS/ML/array0.sats" // un-indexed array
#staload
_(*anon*) = "./DATS/ML/array0.dats" // un-indexed array
//
(* ****** ****** *)

(* end of [mylibies.hats] *)
