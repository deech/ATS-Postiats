(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
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
// Start Time: June, 2011
//
(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

staload _(*anon*) = "prelude/DATS/list.dats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload SYM = "pats_symbol.sats"
staload SYN = "pats_syntax.sats"

macdef
prerr_dqid (dq, id) =
  ($SYN.prerr_d0ynq ,(dq); $SYM.prerr_symbol ,(id))
// end of [prerr_dqid]

(* ****** ****** *)

staload "pats_errmsg.sats"
staload _(*anon*) = "pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_trans2_impdec"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload "pats_staexp1.sats"
staload "pats_dynexp1.sats"
staload "pats_staexp2.sats"
staload "pats_staexp2_util.sats"
staload "pats_dynexp2.sats"
staload "pats_dynexp2_util.sats"

(* ****** ****** *)

staload "pats_trans2.sats"
staload "pats_trans2_env.sats"

(* ****** ****** *)

#define :: list_cons
#define l2l list_of_list_vt
macdef list_sing (x) = list_cons (,(x), list_nil)

(* ****** ****** *)

macdef hnf = s2hnf_of_s2exp
macdef hnflst = s2hnflst_of_s2explst
macdef unhnf = s2exp_of_s2hnf
macdef unhnflst = s2explst_of_s2hnflst

(* ****** ****** *)

fn i1mpdec_select_d2cst (
  d1c0: d1ecl, impdec: i1mpdec
) : Option_vt (d2cst) = let
//
fn auxerr1 (
  d1c: i1mpdec
) :<cloref1> void = let
  val qid = d1c.i1mpdec_qid
  val dq = qid.impqi0de_qua and id = qid.impqi0de_sym
  val () = prerr_error2_loc (d1c.i1mpdec_loc)
  val () = prerr ": there is no suitable dynamic constant declared for ["
  val () = prerr_dqid (dq, id)
  val () = prerr "]."
  val () = prerr_newline ()
  val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
in
  // nothing
end // end of [auxerr1]
fn auxerr2 (
  d1c: i1mpdec
) :<cloref1> void = let
  val qid = d1c.i1mpdec_qid
  val dq = qid.impqi0de_qua and id = qid.impqi0de_sym
  val () = prerr_error2_loc (d1c.i1mpdec_loc)
  val () = prerr ": the identifier ["
  val () = prerr_dqid (dq, id)
  val () = prerr "] does not refer to a declared dynamic constant."
  val () = prerr_newline ()
  val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
in
  // nothing
end // end of [auxerr2]
fn auxerr3 (
  d1c: i1mpdec
) :<cloref1> void = let
  val qid = d1c.i1mpdec_qid
  val dq = qid.impqi0de_qua and id = qid.impqi0de_sym
  val () = prerr_error2_loc (d1c.i1mpdec_loc)
  val () = prerr ": the identifier ["
  val () = prerr_dqid (dq, id)
  val () = prerr "] is unrecognized."
  val () = prerr_newline ()
  val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
in
  // nothing
end // end of [auxerr3]
//
val qid = impdec.i1mpdec_qid
val dq = qid.impqi0de_qua and id = qid.impqi0de_sym
val def = impdec.i1mpdec_def
//
fun aux1 (
  d2is: d2itmlst
) :<cloref1> List_vt (d2cst) =
  case+ d2is of
  | list_cons (d2i, d2is) => (
    case+ d2i of
    | D2ITMcst (d2c) => let
        val ismat = d2cst_match_def (d2c, def)
      in
        if ismat then list_vt_cons (d2c, aux1 (d2is)) else aux1 (d2is)
      end (* end of [D2ITMcst] *)
    | _ => aux1 (d2is)
    ) // end of [list_cons]
  | list_nil () => list_vt_nil ()
(* end of [aux1] *)
fun aux2 (
  d2cs: List_vt (d2cst)
) :<cloref1> Option_vt (d2cst) =
  case+ d2cs of
  | ~list_vt_cons (d2c, d2cs) => let
      val () = list_vt_free (d2cs) in Some_vt (d2c)
    end (* end of [list_vt_cons] *)
  | ~list_vt_nil () => let
      val () = auxerr1 (impdec) in None_vt () // HX: error is reported
    end (* end of [list_vt_nil] *)
(* end of [aux2] *)
//
val ans = the_d2expenv_find_qua (dq, id)
//
in
//
case+ ans of
| ~Some_vt (d2i) => (case+ d2i of
  | D2ITMcst (d2c) => Some_vt (d2c)
  | D2ITMsymdef (d2is) => let
      val d2cs = aux1 (d2is) in aux2 (d2cs)
    end
  | _ => let
      val () = auxerr2 (impdec) in None_vt () // HX: error is reported
    end (* end of [_] *)
  ) // end of [Some_vt]
| ~None_vt () => let
    val () = auxerr3 (impdec) in None_vt () // HX: error is reported
  end (* end of [None_vt] *)
//
end // end of [i1mpdec_select_d2cst]

fun
d1exp_tr_ann (
  d1e0: d1exp, s2f0: s2hnf
) : d2exp = let
  val s2e0 = unhnf (s2f0)
// (*
  val () = (
    print "d1exp_tr_ann: d1e0 = "; print_d1exp (d1e0); print_newline ()
  ) // end of [val]
  val () = (
    print "d1exp_tr_ann: s2e0 = "; print_s2exp (s2e0); print_newline ()
  ) // end of [val]
// *)
  fn auxerr (d1e0: d1exp, loc: location, err: int): void = ()
in
//
case+ s2e0.s2exp_node of
| S2Euni (s2vs, s2ps, s2e) => (
  case+ d1e0.d1exp_node of
  | D1Elam_sta_ana (locarg, arg, body) => let
//
      var err: int = 0
      val (sub, s2vs) =
        s1vararg_bind_svarlst_err (arg, s2vs, err)
      val s2vs = list_of_list_vt (s2vs)
      val () = if err != 0 then auxerr (d1e0, locarg, err)
//
      val (pf_s2expenv | ()) = the_s2expenv_push_nil ()
      val () = the_s2expenv_add_svarlst (s2vs)
      val s2ps = s2explst_subst (sub, s2ps) and s2e = s2exp_subst (sub, s2e)
      val () = stasub_free (sub)
      val s2ps = s2explst_hnfize (s2ps) and s2f = s2exp_hnfize (s2e)
      val body = d1exp_tr_ann (body, s2f)
      val () = the_s2expenv_pop_free (pf_s2expenv | (*none*))
    in
      d2exp_lam_sta (d1e0.d1exp_loc, s2vs, s2ps, body)
    end // end of [D1Elam_sta_ana]
  | _ => let
      val s2f = hnf (s2e)
      val d2e0 = d1exp_tr_ann (d1e0, s2f)
      val s2ps = hnflst (s2ps)
    in
      d2exp_lam_sta (d1e0.d1exp_loc, s2vs, s2ps, d2e0)
    end // end of [_]
  ) // end of [S2Euni]
| S2Efun (
    fc, lin1, s2fe, npf1, s2es_arg, s2e_res
  ) => (
  case+ d1e0.d1exp_node of
  | D1Elam_dyn (lin2, p1t_arg, d1e_body) => let
      val @(p2ts_arg, d2e_body) = d1exp_tr_arg_body_ann (
        d1e0, fc, lin1, s2fe, npf1, s2es_arg, s2e_res, lin2, p1t_arg, d1e_body
      ) // end of [val]
    in
      d2exp_lam_dyn (d1e0.d1exp_loc, lin1, npf1, p2ts_arg, d2e_body)
    end // end of [D2Elam_dyn]
  | D1Elaminit_dyn (lin2, p1t_arg, d1e_body) => let
      val @(p2ts_arg, d2e_body) = d1exp_tr_arg_body_ann (
        d1e0, fc, lin1, s2fe, npf1, s2es_arg, s2e_res, lin2, p1t_arg, d1e_body
      ) // end of [val]
    in
      d2exp_laminit_dyn (d1e0.d1exp_loc, lin1, npf1, p2ts_arg, d2e_body)
    end // end of [D2Elam_dyn]
  | _ => let
      val d2e0 = d1exp_tr (d1e0)
    in
      d2exp_ann_type (d1e0.d1exp_loc, d2e0, s2f0)
    end (* end of [_] *)
  ) // end of [S2Efun]
| _ => let
    val d2e0 = d1exp_tr d1e0 in d2exp_ann_type (d1e0.d1exp_loc, d2e0, s2f0)
  end (* end of [_] *)
//
end // end of [d1exp_tr_ann]

and
d1exp_tr_arg_body_ann (
  d1e0: d1exp
, fc: funclo, lin1: int
, s2fe: s2eff, npf1: int
, s2es_arg: s2explst, s2e_res: s2exp
, lin2: int
, p1t_arg: p1at, d1e_body: d1exp
) : @(p2atlst, d2exp) = let
//
// (*
  val () = (
    print "d1exp_tr_arg_body_ann: p1t_arg = "; print_p1at (p1t_arg); print_newline ();
    print "d1exp_tr_arg_body_ann: s2es_arg = "; print_s2explst (s2es_arg); print_newline ();
  ) // end of [val]
// *)
//
val () = auxcheck (d1e0, fc) where {
  fn auxcheck (
    d1e0: d1exp, fc: funclo
  ) : void =
    case+ fc of
    | FUNCLOclo (knd) when knd = 0 => let
        val () = prerr_error2_loc (d1e0.d1exp_loc)
        val () = prerr ": the function cannot be given an unboxed closure type.";
        val () = prerr_newline ()
      in
        the_trans2errlst_add (T2E_d1exp_tr (d1e0))
      end // end of [FUNCLOclo]
    | _ => ()
} (* end of [val] *)
//
val () = auxcheck
  (d1e0, lin1, lin2) where {
  fn auxcheck (
    d1e0: d1exp, lin1: int, lin2: int
  ) : void =
    if lin1 != lin2 then let
      val () = prerr_error2_loc (d1e0.d1exp_loc)
      val () = if lin1 < lin2 then prerr ": linear function is given a nonlinear type."
      val () = if lin1 > lin2 then prerr ": nonlinear function is given a linear type."
      val () = prerr_newline ()
    in
      the_trans2errlst_add (T2E_d1exp_tr (d1e0))
    end // end of [if]
} (* end of [val] *)
//
var wths1es = WTHS1EXPLSTnil ()
val p2t_arg = 
p1at_tr_arg (p1t_arg, wths1es)
//
val () = auxcheck
  (d1e0, p1t_arg, wths1es) where {
  fn auxcheck ( // check for refval types
    d1e0: d1exp, p1t_arg: p1at, wths1es: wths1explst
  ) : void = let
    val isnone = wths1explst_is_none (wths1es)
  in
    if ~isnone then let
      val () = prerr_error2_loc (p1t_arg.p1at_loc)
      val () = prerr ": the function argument cannot be ascribed refval types."
      val () = prerr_newline ()
    in
      the_trans2errlst_add (T2E_d1exp_tr (d1e0))
    end (* end of [if] *)
  end // end of [auxcheck]
} (* end of [val] *)
//
var npf2: int = ~1
val p2ts_arg = (
  case+ p2t_arg.p2at_node of
  | P2Tlist (npf, p2ts) => (npf2 := npf; p2ts)
  | _ => list_sing (p2t_arg)
) : p2atlst // end of [val]
//
val () = auxcheck
  (d1e0, npf1, npf2) where {
  fn auxcheck (
    d1e0: d1exp, npf1: int, npf2: int
  ) : void =
    if npf1 != npf2 then let // check for pfarity match
      val () = prerr_error2_loc (d1e0.d1exp_loc)
      val () = prerr ": the implementation contains proof arity mismatch."
      val () = prerr_newline ()
    in
      the_trans2errlst_add (T2E_d1exp_tr (d1e0))
    end // end of [if]
} (* end of [val] *)
//
val p2ts_arg = let
//
  fn auxerr (
    d1e0: d1exp, err: int
  ) : void = let
     val () = prerr_error2_loc (d1e0.d1exp_loc)
     val () = if err > 0 then prerr ": less arguments are expected."
     val () = if err < 0 then prerr ": more arguments are expected."
     val () = prerr_newline ()
   in
      the_trans2errlst_add (T2E_d1exp_tr (d1e0))
   end // end of [auxerr]
//
  fun aux (
    p2ts: p2atlst, s2es: s2explst, err: &int
  ) : p2atlst =
    case+ (p2ts, s2es) of
    | (p2t :: p2ts, s2e :: s2es) => let
         val s2f = s2exp_hnfize (s2e)
         val p2t = p2at_ann (p2t.p2at_loc, p2t, s2f)
         val p2ts = aux (p2ts, s2es, err)
       in
         list_cons (p2t, p2ts)
       end
    | (list_nil (), list_nil ()) => list_nil ()
    | (list_cons _, list_nil ()) => let
        val () = err := err + 1 in list_nil ()
      end
    | (list_nil (), list_cons _) => let
        val () = err := err - 1 in list_nil ()
      end
  (* end of [aux] *)
//
  var err: int = 0
  val p2ts_arg = aux (p2ts_arg, s2es_arg, err)
  val () = if err != 0 then auxerr (d1e0, err)
in
  p2ts_arg
end // end of [val]
//
val (pfenv | ()) = the_trans2_env_push ()
val () = let
  val s2vs = $UT.lstord_listize (p2t_arg.p2at_svs)
in
  the_s2expenv_add_svarlst s2vs
end // end of [val]
val () = let
  val d2vs = $UT.lstord_listize (p2t_arg.p2at_dvs)
in
  the_d2expenv_add_dvarlst d2vs
end // end of [val]
//
val (pflev | ()) = the_d2varlev_inc ()
//
val () = auxcheck
  (d1e0, err) where {
  var err: int = 0
  val () = (case+
    d1e_body.d1exp_node of
    | D1Eann_effc _ => (err := err + 1)
    | D1Eann_funclo _ => (err := err + 1)
    | _ => ()
  ) : void // end of [val]
  fn auxcheck (d1e0: d1exp, err: int) =
    if err > 0 then let
      val () = prerr_error2_loc (d1e0.d1exp_loc)
      val () = prerr ": the [funclo/effect] annonation is redundant."
      val () = prerr_newline ()
    in
      the_trans2errlst_add (T2E_d1exp_tr (d1e0))
    end // end of [if]
  // end of [auxcheck]
} (* end of [val] *)
//
val s2f_res = s2exp_hnfize (s2e_res)
val d2e_body = d1exp_tr_ann (d1e_body, s2f_res)
//
val () = the_d2varlev_dec (pflev | (*none*))
val () = the_trans2_env_pop (pfenv | (*none*))
//
val loc_body = d2e_body.d2exp_loc
val d2e_body = d2exp_ann_seff (loc_body, d2e_body, s2fe)
val d2e_body = d2exp_ann_funclo (loc_body, d2e_body, fc)
//
in
  @(p2ts_arg, d2e_body)
end // end of [d2exp_tr_arg_body_ann]

(* ****** ****** *)

fun i1mpdec_tr_main (
  d1c0: d1ecl
, d2c: d2cst, imparg: i1mparg, impdec: i1mpdec
) : i2mpdec = let
//
fun aux_imparg_sarglst (
  d1c0: d1ecl, s1as: s1arglst
) : s2varlst = s2vs where {
  val s2vs = s1arglst_trup (s1as)
  val () = the_s2expenv_add_svarlst (s2vs)
} (* end of [aux_imparg_sarglst] *)
//
fun aux_imparg_svararg (
  d1c0: d1ecl
, s1v: s1vararg, s2qs: s2qualst, out: &s2varlstlst
) : s2qualst = let
//
  fn auxerr1
    ():<cloref1> void = let
    val () = prerr_error2_loc (d1c0.d1ecl_loc)
    val () = prerr ": the implementation is overly applied."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
  in
    // nothing
  end // end of [auxerr1]
  fn auxerr2
    (loc: location, err: int):<cloref1> void = let
    val () = prerr_error2_loc (loc)
    val () = prerr ": the implementation argument group is expected to contain "
    val () = prerr_string (if err > 0 then "less" else "more")
    val () = prerr " components."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
  in
    // nothing
  end // end of [auxerr2]
//
  fun auxseq (
    s1as: s1arglst, s2vs: s2varlst, err: &int
  ) : s2varlst = (
    case+ (s1as, s2vs) of
    | (s1a :: s1as,
       s2v :: s2vs) => let
        val s2t0 = s2var_get_srt (s2v)
        val okay = (case+ s1a.s1arg_srt of
          | Some s1t => let
              val s2t = s1rt_tr (s1t) in s2rt_ltmat1 (s2t0, s2t)
            end // end of [Some]
          | None () => true
        ) : bool // end of [val]
        val s2v = s1arg_trdn (s1a, s2t0)
        val s2vs = auxseq (s1as, s2vs, err)
      in
        list_cons (s2v, s2vs)
      end
    | (list_nil (), list_nil ()) => list_nil ()
    | (list_cons _, list_nil ()) => let
        val () = err := err + 1 in list_nil ()
      end
    | (list_nil (), list_cons _) => let
        val () = err := err - 1 in list_nil ()
      end
  ) (* end of [auxseq] *)
//
in
  case+ s1v of
  | S1VARARGone () => (case+ s2qs of
    | list_cons (s2q, s2qs) => let
        val s2vs = list_map_fun (s2q.s2qua_svs, s2var_dup)
        val s2vs = (l2l)s2vs
        val () = the_s2expenv_add_svarlst (s2vs)
        val () = out := list_cons (s2vs, out)
      in
        s2qs
      end
    | list_nil () => let
        val () = auxerr1 () in list_nil ()
      end
    )
  | S1VARARGall () => (case+ s2qs of
    | list_cons (s2q, s2qs) => let
        val s2vs = list_map_fun (s2q.s2qua_svs, s2var_dup)
        val s2vs = (l2l)s2vs
        val () = the_s2expenv_add_svarlst (s2vs)
        val () = out := list_cons (s2vs, out)
      in
        aux_imparg_svararg (d1c0, s1v, s2qs, out)
      end
    | list_nil () => list_nil ()
    )
  | S1VARARGseq (loc, s1as) => (case+ s2qs of
    | list_cons (s2q, s2qs) => let
        var err: int = 0
        val s2vs = auxseq (s1as, s2q.s2qua_svs, err)
        val () = the_s2expenv_add_svarlst (s2vs)
        val () = if err != 0 then auxerr2 (loc, err)
        val () = out := list_cons (s2vs, out)
      in
        s2qs
      end
    | list_nil () => let
        val () = auxerr1 () in list_nil ()
      end
    )
end // end of [aux_imparg_svararg]
//
fun aux_imparg_svararglst (
  d1c0: d1ecl
, s2qs: s2qualst, s1vs: s1vararglst, out: &s2varlstlst
) : void = let
  fn auxerr ():<cloref1> void = let
    val () = prerr_error2_loc (d1c0.d1ecl_loc)
    val () = prerr ": the implementation is expected to be fully applied."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_impdec_tr (d1c0))
  in
    // nothing
  end // end of [auxerr]
in
  case+ s1vs of
  | s1v :: s1vs => let
      val s2qs = aux_imparg_svararg (d1c0, s1v, s2qs, out)
    in
      aux_imparg_svararglst (d1c0, s2qs, s1vs, out)
    end // end of [::]
  | list_nil () =>  ( // HX: make sure the implementation is fully applied
    case+ s2qs of
    | list_cons _ => let 
        val () = auxerr () in ()
      end // end of [list_cons]
    | list_nil () => ()
    ) (* end of [list_nil] *)
end // end of [aux_imparg_svararglst]
//
fun aux_imparg (
  d1c0: d1ecl, s2qs: s2qualst, imparg: i1mparg
) : (s2varlst, Option_vt (s2varlstlst)) =
  case+ imparg of
  | I1MPARG_sarglst (s1as) => let
      val s2vs = aux_imparg_sarglst (d1c0, s1as)
    in
      (s2vs, None_vt ())
    end
  | I1MPARG_svararglst (s1vs) => let
      var out: s2varlstlst = list_nil ()
      val () = aux_imparg_svararglst (d1c0, s2qs, s1vs, out)
      val out = l2l (list_reverse (out))
      val s2vs = l2l (list_concat (out))
    in
      (s2vs, Some_vt (out))
    end
(* end of [aux_imparg] *)
//
fun aux_tmparg_s1explst (
  d1c0: d1ecl
, s2vs: s2varlst, s1es: s1explst, err: &int
) : s2hnflst = let
(*
  val () = (
    print "aux_tmparg_s1explst: s2vs = "; print_s2varlst (s2vs); print_newline ()
  ) // end of [val]
*)
in
  case+ (s2vs, s1es) of
  | (s2v :: s2vs, s1e :: s1es) => let
      val s2t = s2var_get_srt (s2v)
      val s2e = s1exp_trdn (s1e, s2t)
      val s2f = s2exp_hnfize (s2e)
      val s2fs = aux_tmparg_s1explst (d1c0, s2vs, s1es, err)
    in
      list_cons (s2f, s2fs)
    end // end of [::, ::]
  | (list_nil (), list_nil ()) => list_nil ()
  | (list_cons _, list_nil ()) => let
      val () = err := err + 1 in list_nil ()
    end
  | (list_nil (), list_cons _) => let 
      val () = err := err - 1 in list_nil ()
    end
end // end of [aux_tmparg_s1explst]
//
fun aux_tmparg_marglst (
  d1c0: d1ecl, s2qs: s2qualst, xs: t1mpmarglst
) : s2hnflstlst = let
  fn auxerr1 (x: t1mpmarg, err: int):<cloref1> void = let
    val () = prerr_error2_loc (x.t1mpmarg_loc)
    val () = prerr ": the template argument group is expected to be contain "
    val () = prerr_string (if err > 0 then "more" else "less")
    val () = prerr " components."
    val () = prerr_newline ()
  in
    the_trans2errlst_add (T2E_impdec_tr (d1c0))
  end // end of [auxerr1]
  fn auxerr2 ():<cloref1> void = let
    val () = prerr_error2_loc (d1c0.d1ecl_loc)
    val () = prerr ": the template is expected to be fully applied but it is not."
    val () = prerr_newline ()
  in
    the_trans2errlst_add (T2E_impdec_tr (d1c0))
  end // end of [auxerr2]
  fn auxerr3 ():<cloref1> void = let
    val () = prerr_error2_loc (d1c0.d1ecl_loc)
    val () = prerr ": the template is overly applied."
    val () = prerr_newline ()
  in
    the_trans2errlst_add (T2E_impdec_tr (d1c0))
  end // end of [auxerr3]
in
  case+ (s2qs, xs) of
  | (s2q :: s2qs, x :: xs) => let
      var err: int = 0
      val s2es = aux_tmparg_s1explst
        (d1c0, s2q.s2qua_svs, x.t1mpmarg_arg, err)
      val () = if err != 0 then auxerr1 (x, err)
      val s2ess = aux_tmparg_marglst (d1c0, s2qs, xs)
    in
      list_cons (s2es, s2ess)
    end
  | (list_nil (), list_nil ()) => list_nil ()
  | (list_cons _, list_nil ()) => let
      val () = auxerr2 () in list_nil ()
    end
  | (list_nil (), list_cons _) => let
      val () = auxerr3 () in list_nil ()
    end
end // end of [aux_tmparg_s1explstlst]
//
fun aux_tmparg (
  d1c0: d1ecl, s2qs: s2qualst, impdec: i1mpdec
) : s2hnflstlst = let
in
  aux_tmparg_marglst (d1c0, s2qs, impdec.i1mpdec_tmparg)
end // end of [aux_tmparg]
//
val s2qs = d2cst_get_decarg (d2c)
val (pfenv | ()) = the_s2expenv_push_nil ()
val () = if list_isnot_empty (s2qs) then the_tmplev_inc ()
//
val (imparg, opt) = aux_imparg (d1c0, s2qs, imparg)
val sfess = (case+ opt of
  | ~Some_vt (s2vss) => let
      fn f (
        s2vs: s2varlst
      ) : s2hnflst =
         l2l (list_map_fun (s2vs, s2exp_var))
      // end of [f]
    in
      l2l (list_map_fun (s2vss, f))
    end // end of [Some]
  | ~None_vt () => aux_tmparg (d1c0, s2qs, impdec)
) : s2hnflstlst // end of [val]
//
val tmparg = sfess
val tmpgua = list_nil ()
//
val s2f = d2cst_get_type (d2c)
val d2e = d1exp_tr_ann (impdec.i1mpdec_def, s2f)
//
val () = if list_isnot_empty (s2qs) then the_tmplev_dec ()
val () = the_s2expenv_pop_free (pfenv | (*none*))
//
val () = d2cst_set_def (d2c, Some d2e)
//
val loc = impdec.i1mpdec_loc
val qid = impdec.i1mpdec_qid
val locid = qid.impqi0de_loc
//
in
//
i2mpdec_make (loc, locid, d2c, imparg, tmparg, tmpgua, d2e)
//
end // end of [i1mpdec_tr_main]

(* ****** ****** *)

implement
i1mpdec_tr (d1c0) = let
  val- D1Cimpdec
    (imparg, impdec) = d1c0.d1ecl_node
  val d2copt = i1mpdec_select_d2cst (d1c0, impdec)
in
  case+ d2copt of
  | ~Some_vt (d2c) => let
      val impdec = i1mpdec_tr_main (d1c0, d2c, imparg, impdec)
    in
      Some_vt (impdec)
    end // end of [Some_vt]
  | ~None_vt () => None_vt ()
end // end of [i1mpdec_tr]

(* ****** ****** *)

(* end of [pats_trans2_impdec.dats] *)
