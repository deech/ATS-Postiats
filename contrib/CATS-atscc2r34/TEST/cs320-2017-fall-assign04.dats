(* ****** ****** *)
//
// HX-2017-10:
// A running example
// from ATS2 to R(stat)
//
(* ****** ****** *)
//
#define
ATS_MAINATSFLAG 1
#define
ATS_DYNLOADNAME "my_dynload"
//
(* ****** ****** *)
//
#define
LIBATSCC2R34_targetloc
"$PATSHOME/contrib/libatscc2r34"
//
(* ****** ****** *)
//
#include "{$LIBATSCC2R34}/mylibies.hats"
//
(* ****** ****** *)

#define
NDX100_fname "./DATA/NDX100-index.csv"

(* ****** ****** *)

abstype optarg

(* ****** ****** *)

val
NDX100_dframe =
$extfcall
( R34dframe(double)
, "read.csv"
, NDX100_fname, $extval(optarg,"header=TRUE")
)

(* ****** ****** *)

val
NDX100_dframe_names = names(NDX100_dframe)

(* ****** ****** *)
//
val () =
println!
("length(NDX100_dframe_names) = ", length(NDX100_dframe_names))
//
(* ****** ****** *)

(*
val () =
assertloc(length(NDX100_dframe_names) >= 7)
val () =
println!("NDX100_dframe_names[1] = ", NDX100_dframe_names[1])
val () =
println!("NDX100_dframe_names[2] = ", NDX100_dframe_names[2])
val () =
println!("NDX100_dframe_names[3] = ", NDX100_dframe_names[3])
val () =
println!("NDX100_dframe_names[4] = ", NDX100_dframe_names[4])
val () =
println!("NDX100_dframe_names[5] = ", NDX100_dframe_names[5])
val () =
println!("NDX100_dframe_names[6] = ", NDX100_dframe_names[6])
val () =
println!("NDX100_dframe_names[7] = ", NDX100_dframe_names[7])
val () = // HX: this one is out-of-bounds
println!("NDX100_dframe_names[8] = ", NDX100_dframe_names[8])
*)

(* ****** ****** *)
//
val
Adj_Close_pos =
match("Adj.Close", NDX100_dframe_names)
val ((*void*)) =
println! ("Adj_Close_pos = ", Adj_Close_pos)
val ((*void*)) = assertloc(Adj_Close_pos > 0)
//
(* ****** ****** *)
//
val
Adj_Close_data =
getcol_at(NDX100_dframe, Adj_Close_pos)
val ((*void*)) =
println! ("|Adj_Close_data| = ", length(Adj_Close_data))
//
(* ****** ****** *)

val
Adj_Close_data2 =
R34vector_map_cloref(Adj_Close_data, lam(x) => x / 100)

(* ****** ****** *)

(*
val () = $extfcall(void, "message", Adj_Close_data)
val () = $extfcall(void, "message", Adj_Close_data2)
*)

(* ****** ****** *)


%{^
######
if
(
!(exists("libatscc2r34.is.loaded"))
)
{
  assign("libatscc2r34.is.loaded", FALSE)
}
######
if
(
!(libatscc2r34.is.loaded)
)
{
  sys.source("./libatscc2r34/libatscc2r34_all.R")
}
######
%} // end of [%{^]

(* ****** ****** *)

%{$
my_dynload()
%} // end of [%{$]

(* ****** ****** *)

(* end of [cs320-2017-fall-assign04.dats] *)
