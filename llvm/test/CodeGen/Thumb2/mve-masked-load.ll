; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve,+fullfp16 -enable-arm-maskedldst -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-arm-none-eabi -mattr=+mve,+fullfp16 -enable-arm-maskedldst -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-BE

define arm_aapcs_vfpcc <4 x i32> @masked_v4i32_align4_zero(<4 x i32> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q1, [r0]
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %dest, i32 4, <4 x i1> %c, <4 x i32> zeroinitializer)
  ret <4 x i32> %l
}

define arm_aapcs_vfpcc <4 x i32> @masked_v4i32_align4_undef(<4 x i32> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_align4_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_align4_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q1, [r0]
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %dest, i32 4, <4 x i1> %c, <4 x i32> undef)
  ret <4 x i32> %l
}

define arm_aapcs_vfpcc <4 x i32> @masked_v4i32_align1_undef(<4 x i32> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_align1_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_align1_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vrev32.8 q1, q0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %dest, i32 1, <4 x i1> %c, <4 x i32> undef)
  ret <4 x i32> %l
}

define arm_aapcs_vfpcc <4 x i32> @masked_v4i32_align4_other(<4 x i32> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_align4_other:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q1, [r0]
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_align4_other:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %dest, i32 4, <4 x i1> %c, <4 x i32> %a)
  ret <4 x i32> %l
}

define arm_aapcs_vfpcc i8* @masked_v4i32_preinc(i8* %x, i8* %y, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_preinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0, #4]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_preinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0, #4]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrw.32 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i32>*
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %1 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %0, i32 4, <4 x i1> %c, <4 x i32> undef)
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define arm_aapcs_vfpcc i8* @masked_v4i32_postinc(i8* %x, i8* %y, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4i32_postinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4i32_postinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrw.32 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i32>*
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %1 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %0, i32 4, <4 x i1> %c, <4 x i32> undef)
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}



define arm_aapcs_vfpcc <8 x i16> @masked_v8i16_align4_zero(<8 x i16> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.16 q2, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q2, zr
; CHECK-BE-NEXT:    vrev32.16 q1, q1
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %dest, i32 2, <8 x i1> %c, <8 x i16> zeroinitializer)
  ret <8 x i16> %l
}

define arm_aapcs_vfpcc <8 x i16> @masked_v8i16_align4_undef(<8 x i16> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_align4_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_align4_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q1, [r0]
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %dest, i32 2, <8 x i1> %c, <8 x i16> undef)
  ret <8 x i16> %l
}

define arm_aapcs_vfpcc <8 x i16> @masked_v8i16_align1_undef(<8 x i16> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_align1_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_align1_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vrev16.8 q1, q0
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %dest, i32 1, <8 x i1> %c, <8 x i16> undef)
  ret <8 x i16> %l
}

define arm_aapcs_vfpcc <8 x i16> @masked_v8i16_align4_other(<8 x i16> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_align4_other:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q1, [r0]
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_align4_other:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %dest, i32 2, <8 x i1> %c, <8 x i16> %a)
  ret <8 x i16> %l
}

define i8* @masked_v8i16_preinc(i8* %x, i8* %y, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_preinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vldr d1, [sp]
; CHECK-LE-NEXT:    vmov d0, r2, r3
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0, #4]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_preinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vldr d1, [sp]
; CHECK-BE-NEXT:    vmov d0, r3, r2
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0, #4]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrh.16 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x i16>*
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %1 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %0, i32 4, <8 x i1> %c, <8 x i16> undef)
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 4
  ret i8* %z
}

define arm_aapcs_vfpcc i8* @masked_v8i16_postinc(i8* %x, i8* %y, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8i16_postinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8i16_postinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrh.16 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x i16>*
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %1 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %0, i32 4, <8 x i1> %c, <8 x i16> undef)
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 4
  ret i8* %z
}


define arm_aapcs_vfpcc <16 x i8> @masked_v16i8_align4_zero(<16 x i8> *%dest, <16 x i8> %a) {
; CHECK-LE-LABEL: masked_v16i8_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v16i8_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.8 q2, q0
; CHECK-BE-NEXT:    vcmp.s8 gt, q2, zr
; CHECK-BE-NEXT:    vrev32.8 q1, q1
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <16 x i8> %a, zeroinitializer
  %l = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %dest, i32 1, <16 x i1> %c, <16 x i8> zeroinitializer)
  ret <16 x i8> %l
}

define arm_aapcs_vfpcc <16 x i8> @masked_v16i8_align4_undef(<16 x i8> *%dest, <16 x i8> %a) {
; CHECK-LE-LABEL: masked_v16i8_align4_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v16i8_align4_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vcmp.s8 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q1, [r0]
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <16 x i8> %a, zeroinitializer
  %l = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %dest, i32 1, <16 x i1> %c, <16 x i8> undef)
  ret <16 x i8> %l
}

define arm_aapcs_vfpcc <16 x i8> @masked_v16i8_align4_other(<16 x i8> *%dest, <16 x i8> %a) {
; CHECK-LE-LABEL: masked_v16i8_align4_other:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q1, [r0]
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v16i8_align4_other:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vcmp.s8 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <16 x i8> %a, zeroinitializer
  %l = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %dest, i32 1, <16 x i1> %c, <16 x i8> %a)
  ret <16 x i8> %l
}

define arm_aapcs_vfpcc i8* @masked_v16i8_preinc(i8* %x, i8* %y, <16 x i8> %a) {
; CHECK-LE-LABEL: masked_v16i8_preinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0, #4]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v16i8_preinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vcmp.s8 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0, #4]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrb.8 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <16 x i8>*
  %c = icmp sgt <16 x i8> %a, zeroinitializer
  %1 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %0, i32 4, <16 x i1> %c, <16 x i8> undef)
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 4
  ret i8* %z
}

define arm_aapcs_vfpcc i8* @masked_v16i8_postinc(i8* %x, i8* %y, <16 x i8> %a) {
; CHECK-LE-LABEL: masked_v16i8_postinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v16i8_postinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vcmp.s8 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrb.8 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <16 x i8>*
  %c = icmp sgt <16 x i8> %a, zeroinitializer
  %1 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %0, i32 4, <16 x i1> %c, <16 x i8> undef)
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 4
  ret i8* %z
}


define arm_aapcs_vfpcc <4 x float> @masked_v4f32_align4_zero(<4 x float> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4f32_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vcmp.s32 gt, q2, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %dest, i32 4, <4 x i1> %c, <4 x float> zeroinitializer)
  ret <4 x float> %l
}

define arm_aapcs_vfpcc <4 x float> @masked_v4f32_align4_undef(<4 x float> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4f32_align4_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_align4_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q1, [r0]
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %dest, i32 4, <4 x i1> %c, <4 x float> undef)
  ret <4 x float> %l
}

define arm_aapcs_vfpcc <4 x float> @masked_v4f32_align1_undef(<4 x float> *%dest, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4f32_align1_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_align1_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vrev32.8 q1, q0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %dest, i32 1, <4 x i1> %c, <4 x float> undef)
  ret <4 x float> %l
}

define arm_aapcs_vfpcc <4 x float> @masked_v4f32_align4_other(<4 x float> *%dest, <4 x i32> %a, <4 x float> %b) {
; CHECK-LE-LABEL: masked_v4f32_align4_other:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_align4_other:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q2
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %l = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %dest, i32 4, <4 x i1> %c, <4 x float> %b)
  ret <4 x float> %l
}

define arm_aapcs_vfpcc i8* @masked_v4f32_preinc(i8* %x, i8* %y, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4f32_preinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0, #4]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_preinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0, #4]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrw.32 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x float>*
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %1 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %c, <4 x float> undef)
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 4
  ret i8* %z
}

define arm_aapcs_vfpcc i8* @masked_v4f32_postinc(i8* %x, i8* %y, <4 x i32> %a) {
; CHECK-LE-LABEL: masked_v4f32_postinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v4f32_postinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrwt.u32 q0, [r0]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrw.32 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x float>*
  %c = icmp sgt <4 x i32> %a, zeroinitializer
  %1 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %c, <4 x float> undef)
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 4
  ret i8* %z
}


define arm_aapcs_vfpcc <8 x half> @masked_v8f16_align4_zero(<8 x half> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8f16_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.16 q2, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q2, zr
; CHECK-BE-NEXT:    vrev32.16 q1, q1
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q1
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %dest, i32 2, <8 x i1> %c, <8 x half> zeroinitializer)
  ret <8 x half> %l
}

define arm_aapcs_vfpcc <8 x half> @masked_v8f16_align4_undef(<8 x half> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8f16_align4_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_align4_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q1, [r0]
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %dest, i32 2, <8 x i1> %c, <8 x half> undef)
  ret <8 x half> %l
}

define arm_aapcs_vfpcc <8 x half> @masked_v8f16_align1_undef(<8 x half> *%dest, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8f16_align1_undef:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_align1_undef:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrbt.u8 q0, [r0]
; CHECK-BE-NEXT:    vrev16.8 q1, q0
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %dest, i32 1, <8 x i1> %c, <8 x half> undef)
  ret <8 x half> %l
}

define arm_aapcs_vfpcc <8 x half> @masked_v8f16_align4_other(<8 x half> *%dest, <8 x i16> %a, <8 x half> %b) {
; CHECK-LE-LABEL: masked_v8f16_align4_other:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_align4_other:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q2, q1
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    vpsel q1, q0, q2
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %l = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %dest, i32 2, <8 x i1> %c, <8 x half> %b)
  ret <8 x half> %l
}

define arm_aapcs_vfpcc i8* @masked_v8f16_preinc(i8* %x, i8* %y, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8f16_preinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0, #4]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_preinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0, #4]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrh.16 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x half>*
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %1 = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %0, i32 4, <8 x i1> %c, <8 x half> undef)
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 4
  ret i8* %z
}

define arm_aapcs_vfpcc i8* @masked_v8f16_postinc(i8* %x, i8* %y, <8 x i16> %a) {
; CHECK-LE-LABEL: masked_v8f16_postinc:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-LE-NEXT:    vpst
; CHECK-LE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-LE-NEXT:    adds r0, #4
; CHECK-LE-NEXT:    vstrw.32 q0, [r1]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: masked_v8f16_postinc:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-BE-NEXT:    vpst
; CHECK-BE-NEXT:    vldrht.u16 q0, [r0]
; CHECK-BE-NEXT:    adds r0, #4
; CHECK-BE-NEXT:    vstrh.16 q0, [r1]
; CHECK-BE-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x half>*
  %c = icmp sgt <8 x i16> %a, zeroinitializer
  %1 = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %0, i32 4, <8 x i1> %c, <8 x half> undef)
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 4
  ret i8* %z
}


define arm_aapcs_vfpcc <2 x i64> @masked_v2i64_align4_zero(<2 x i64> *%dest, <2 x i64> %a) {
; CHECK-LE-LABEL: masked_v2i64_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    vmov r3, s0
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vmov r1, s1
; CHECK-LE-NEXT:    vmov r12, s3
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    vmov r3, s2
; CHECK-LE-NEXT:    sbcs.w r1, r2, r1
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r12
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    beq .LBB29_2
; CHECK-LE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-LE-NEXT:    vldr d1, .LCPI29_0
; CHECK-LE-NEXT:    vldr d0, [r0]
; CHECK-LE-NEXT:    b .LBB29_3
; CHECK-LE-NEXT:  .LBB29_2:
; CHECK-LE-NEXT:    vmov.i32 q0, #0x0
; CHECK-LE-NEXT:  .LBB29_3: @ %else
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    it mi
; CHECK-LE-NEXT:    vldrmi d1, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    bx lr
; CHECK-LE-NEXT:    .p2align 3
; CHECK-LE-NEXT:  @ %bb.4:
; CHECK-LE-NEXT:  .LCPI29_0:
; CHECK-LE-NEXT:    .long 0 @ double 0
; CHECK-LE-NEXT:    .long 0
;
; CHECK-BE-LABEL: masked_v2i64_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    movs r2, #0
; CHECK-BE-NEXT:    vmov r3, s7
; CHECK-BE-NEXT:    vmov r1, s6
; CHECK-BE-NEXT:    vmov r12, s4
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    vmov r3, s5
; CHECK-BE-NEXT:    sbcs.w r1, r2, r1
; CHECK-BE-NEXT:    mov.w r1, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r1, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    sbcs.w r3, r2, r12
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r2, #1
; CHECK-BE-NEXT:    cmp r2, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r2, #1
; CHECK-BE-NEXT:    bfi r2, r1, #0, #1
; CHECK-BE-NEXT:    and r1, r2, #3
; CHECK-BE-NEXT:    lsls r2, r2, #31
; CHECK-BE-NEXT:    beq .LBB29_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    vldr d1, .LCPI29_0
; CHECK-BE-NEXT:    vldr d0, [r0]
; CHECK-BE-NEXT:    b .LBB29_3
; CHECK-BE-NEXT:  .LBB29_2:
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:  .LBB29_3: @ %else
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    it mi
; CHECK-BE-NEXT:    vldrmi d1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    bx lr
; CHECK-BE-NEXT:    .p2align 3
; CHECK-BE-NEXT:  @ %bb.4:
; CHECK-BE-NEXT:  .LCPI29_0:
; CHECK-BE-NEXT:    .long 0 @ double 0
; CHECK-BE-NEXT:    .long 0
entry:
  %c = icmp sgt <2 x i64> %a, zeroinitializer
  %l = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* %dest, i32 8, <2 x i1> %c, <2 x i64> zeroinitializer)
  ret <2 x i64> %l
}

define arm_aapcs_vfpcc <2 x double> @masked_v2f64_align4_zero(<2 x double> *%dest, <2 x double> %a, <2 x i64> %b) {
; CHECK-LE-LABEL: masked_v2f64_align4_zero:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    vmov r3, s4
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vmov r1, s5
; CHECK-LE-NEXT:    vmov r12, s7
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    vmov r3, s6
; CHECK-LE-NEXT:    sbcs.w r1, r2, r1
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r12
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    beq .LBB30_2
; CHECK-LE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-LE-NEXT:    vldr d1, .LCPI30_0
; CHECK-LE-NEXT:    vldr d0, [r0]
; CHECK-LE-NEXT:    b .LBB30_3
; CHECK-LE-NEXT:  .LBB30_2:
; CHECK-LE-NEXT:    vmov.i32 q0, #0x0
; CHECK-LE-NEXT:  .LBB30_3: @ %else
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    it mi
; CHECK-LE-NEXT:    vldrmi d1, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    bx lr
; CHECK-LE-NEXT:    .p2align 3
; CHECK-LE-NEXT:  @ %bb.4:
; CHECK-LE-NEXT:  .LCPI30_0:
; CHECK-LE-NEXT:    .long 0 @ double 0
; CHECK-LE-NEXT:    .long 0
;
; CHECK-BE-LABEL: masked_v2f64_align4_zero:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    movs r2, #0
; CHECK-BE-NEXT:    vmov r3, s3
; CHECK-BE-NEXT:    vmov r1, s2
; CHECK-BE-NEXT:    vmov r12, s0
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    vmov r3, s1
; CHECK-BE-NEXT:    sbcs.w r1, r2, r1
; CHECK-BE-NEXT:    mov.w r1, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r1, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    sbcs.w r3, r2, r12
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r2, #1
; CHECK-BE-NEXT:    cmp r2, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r2, #1
; CHECK-BE-NEXT:    bfi r2, r1, #0, #1
; CHECK-BE-NEXT:    and r1, r2, #3
; CHECK-BE-NEXT:    lsls r2, r2, #31
; CHECK-BE-NEXT:    beq .LBB30_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    vldr d1, .LCPI30_0
; CHECK-BE-NEXT:    vldr d0, [r0]
; CHECK-BE-NEXT:    b .LBB30_3
; CHECK-BE-NEXT:  .LBB30_2:
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:  .LBB30_3: @ %else
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    it mi
; CHECK-BE-NEXT:    vldrmi d1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    bx lr
; CHECK-BE-NEXT:    .p2align 3
; CHECK-BE-NEXT:  @ %bb.4:
; CHECK-BE-NEXT:  .LCPI30_0:
; CHECK-BE-NEXT:    .long 0 @ double 0
; CHECK-BE-NEXT:    .long 0
entry:
  %c = icmp sgt <2 x i64> %b, zeroinitializer
  %l = call <2 x double> @llvm.masked.load.v2f64.p0v2f64(<2 x double>* %dest, i32 8, <2 x i1> %c, <2 x double> zeroinitializer)
  ret <2 x double> %l
}

declare <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32, <8 x i1>, <8 x i16>)
declare <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>*, i32, <16 x i1>, <16 x i8>)
declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32, <4 x i1>, <4 x float>)
declare <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>*, i32, <8 x i1>, <8 x half>)
declare <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>*, i32, <2 x i1>, <2 x i64>)
declare <2 x double> @llvm.masked.load.v2f64.p0v2f64(<2 x double>*, i32, <2 x i1>, <2 x double>)
