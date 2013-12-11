(*
** Arrayptr in ATS for use in Java
*)

(* ****** ****** *)

#define ATS_DYNLOADFLAG 0  
  
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload UN =
"prelude/SATS/unsafe.sats"
//
(* ****** ****** *)

staload "./../SATS/jni.sats"

(* ****** ****** *)

staload "./../SATS/Arrayptr.sats"

(* ****** ****** *)

implement
Java_Arrayptr_make_1elt
(
  jenv, jclass, asz, x0
) = let
  val asz = g1ofg0 ($UN.cast2size(asz))
  val A = arrayptr_make_elt<jlong> (asz, x0)
in
  $UN.castvwtp0{jlong}(A)
end // end of [Java_Arrayptr_make_1elt]

(* ****** ****** *)

implement
Java_Arrayptr_get_1at
(
  jenv, jclass, A, i
) = let
  val [i:int] i =
    g1ofg0 ($UN.cast2size(i))
  val A = $UN.cast{arrayref(jlong, i+1)}(A)
in
  A[i]
end // end of [Java_Arrayptr_get_1at]

(* ****** ****** *)

implement
Java_Arrayptr_set_1at
(
  jenv, jclass, A, i, x
) = let
  val [i:int] i =
    g1ofg0 ($UN.cast2size(i))
  val A = $UN.cast{arrayref(jlong, i+1)}(A)
in
  A[i] := x
end // end of [Java_Arrayptr_set_1at]

(* ****** ****** *)

implement
Java_Arrayptr_free
  (jenv, jclass, A) =
  arrayptr_free ($UN.castvwtp0{arrayptr(jlong,0)}(A))
// end of [Java_Arrayptr_free]

(* ****** ****** *)

(* end of [Arrayptr.dats] *)
