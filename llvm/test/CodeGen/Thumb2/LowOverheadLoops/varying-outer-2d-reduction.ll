; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=enabled %s -o - | \
; RUN:   FileCheck %s --check-prefix=ENABLED
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=force-enabled %s -o - | \
; RUN:   FileCheck %s  --check-prefix=FORCE
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=enabled-no-reductions %s -o - | \
; RUN:   FileCheck %s --check-prefix=NOREDUCTIONS
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=force-enabled-no-reductions %s -o - | \
; RUN:   FileCheck %s --check-prefix=FORCENOREDUCTIONS

define dso_local void @varying_outer_2d_reduction(i16* nocapture readonly %Input, i16* nocapture %Output, i16 signext %Size, i16 signext %N, i16 signext %Scale) local_unnamed_addr {
; ENABLED-LABEL: varying_outer_2d_reduction:
; ENABLED:       @ %bb.0: @ %entry
; ENABLED-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; ENABLED-NEXT:    sub sp, #8
; ENABLED-NEXT:    cmp r3, #1
; ENABLED-NEXT:    str r0, [sp, #4] @ 4-byte Spill
; ENABLED-NEXT:    blt .LBB0_8
; ENABLED-NEXT:  @ %bb.1: @ %for.body.lr.ph
; ENABLED-NEXT:    ldr r0, [sp, #44]
; ENABLED-NEXT:    adr r7, .LCPI0_0
; ENABLED-NEXT:    ldr.w r10, [sp, #4] @ 4-byte Reload
; ENABLED-NEXT:    add.w r9, r2, #3
; ENABLED-NEXT:    vldrw.u32 q0, [r7]
; ENABLED-NEXT:    mov.w r11, #0
; ENABLED-NEXT:    uxth r0, r0
; ENABLED-NEXT:    rsbs r5, r0, #0
; ENABLED-NEXT:    str.w r9, [sp] @ 4-byte Spill
; ENABLED-NEXT:    b .LBB0_4
; ENABLED-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    movs r0, #0
; ENABLED-NEXT:  .LBB0_3: @ %for.end
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    lsrs r0, r0, #16
; ENABLED-NEXT:    sub.w r9, r9, #1
; ENABLED-NEXT:    strh.w r0, [r1, r11, lsl #1]
; ENABLED-NEXT:    add.w r11, r11, #1
; ENABLED-NEXT:    add.w r10, r10, #2
; ENABLED-NEXT:    cmp r11, r3
; ENABLED-NEXT:    beq .LBB0_8
; ENABLED-NEXT:  .LBB0_4: @ %for.body
; ENABLED-NEXT:    @ =>This Loop Header: Depth=1
; ENABLED-NEXT:    @ Child Loop BB0_6 Depth 2
; ENABLED-NEXT:    cmp r2, r11
; ENABLED-NEXT:    ble .LBB0_2
; ENABLED-NEXT:  @ %bb.5: @ %vector.ph
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    bic r7, r9, #3
; ENABLED-NEXT:    movs r6, #1
; ENABLED-NEXT:    subs r7, #4
; ENABLED-NEXT:    sub.w r0, r2, r11
; ENABLED-NEXT:    vmov.i32 q2, #0x0
; ENABLED-NEXT:    add.w r8, r6, r7, lsr #2
; ENABLED-NEXT:    ldr r7, [sp] @ 4-byte Reload
; ENABLED-NEXT:    sub.w r4, r7, r11
; ENABLED-NEXT:    movs r7, #0
; ENABLED-NEXT:    bic r4, r4, #3
; ENABLED-NEXT:    subs r4, #4
; ENABLED-NEXT:    add.w r4, r6, r4, lsr #2
; ENABLED-NEXT:    subs r6, r0, #1
; ENABLED-NEXT:    dls lr, r4
; ENABLED-NEXT:    mov r4, r10
; ENABLED-NEXT:    ldr r0, [sp, #4] @ 4-byte Reload
; ENABLED-NEXT:  .LBB0_6: @ %vector.body
; ENABLED-NEXT:    @ Parent Loop BB0_4 Depth=1
; ENABLED-NEXT:    @ => This Inner Loop Header: Depth=2
; ENABLED-NEXT:    vmov q1, q2
; ENABLED-NEXT:    vadd.i32 q2, q0, r7
; ENABLED-NEXT:    vdup.32 q3, r7
; ENABLED-NEXT:    mov lr, r8
; ENABLED-NEXT:    vcmp.u32 hi, q3, q2
; ENABLED-NEXT:    vdup.32 q3, r6
; ENABLED-NEXT:    vpnot
; ENABLED-NEXT:    sub.w r8, r8, #1
; ENABLED-NEXT:    vpsttt
; ENABLED-NEXT:    vcmpt.u32 cs, q3, q2
; ENABLED-NEXT:    vldrht.s32 q2, [r0], #8
; ENABLED-NEXT:    vldrht.s32 q3, [r4], #8
; ENABLED-NEXT:    adds r7, #4
; ENABLED-NEXT:    vmul.i32 q2, q3, q2
; ENABLED-NEXT:    vshl.s32 q2, r5
; ENABLED-NEXT:    vadd.i32 q2, q2, q1
; ENABLED-NEXT:    le lr, .LBB0_6
; ENABLED-NEXT:  @ %bb.7: @ %middle.block
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    vpsel q1, q2, q1
; ENABLED-NEXT:    vaddv.u32 r0, q1
; ENABLED-NEXT:    b .LBB0_3
; ENABLED-NEXT:  .LBB0_8: @ %for.end17
; ENABLED-NEXT:    add sp, #8
; ENABLED-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11, pc}
; ENABLED-NEXT:    .p2align 4
; ENABLED-NEXT:  @ %bb.9:
; ENABLED-NEXT:  .LCPI0_0:
; ENABLED-NEXT:    .long 0 @ 0x0
; ENABLED-NEXT:    .long 1 @ 0x1
; ENABLED-NEXT:    .long 2 @ 0x2
; ENABLED-NEXT:    .long 3 @ 0x3
;
; FORCE-LABEL: varying_outer_2d_reduction:
; FORCE:       @ %bb.0: @ %entry
; FORCE-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; FORCE-NEXT:    sub sp, #4
; FORCE-NEXT:    cmp r3, #1
; FORCE-NEXT:    str r0, [sp] @ 4-byte Spill
; FORCE-NEXT:    blt .LBB0_8
; FORCE-NEXT:  @ %bb.1: @ %for.body.lr.ph
; FORCE-NEXT:    ldr r0, [sp, #36]
; FORCE-NEXT:    add.w r12, r2, #3
; FORCE-NEXT:    ldr.w r10, [sp] @ 4-byte Reload
; FORCE-NEXT:    movs r6, #0
; FORCE-NEXT:    mov r9, r12
; FORCE-NEXT:    uxth r0, r0
; FORCE-NEXT:    rsbs r5, r0, #0
; FORCE-NEXT:    b .LBB0_4
; FORCE-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; FORCE-NEXT:    movs r0, #0
; FORCE-NEXT:  .LBB0_3: @ %for.end
; FORCE-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCE-NEXT:    lsrs r0, r0, #16
; FORCE-NEXT:    sub.w r9, r9, #1
; FORCE-NEXT:    strh.w r0, [r1, r6, lsl #1]
; FORCE-NEXT:    adds r6, #1
; FORCE-NEXT:    add.w r10, r10, #2
; FORCE-NEXT:    cmp r6, r3
; FORCE-NEXT:    beq .LBB0_8
; FORCE-NEXT:  .LBB0_4: @ %for.body
; FORCE-NEXT:    @ =>This Loop Header: Depth=1
; FORCE-NEXT:    @ Child Loop BB0_6 Depth 2
; FORCE-NEXT:    cmp r2, r6
; FORCE-NEXT:    ble .LBB0_2
; FORCE-NEXT:  @ %bb.5: @ %vector.ph
; FORCE-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCE-NEXT:    bic r0, r9, #3
; FORCE-NEXT:    movs r7, #1
; FORCE-NEXT:    subs r0, #4
; FORCE-NEXT:    subs r4, r2, r6
; FORCE-NEXT:    vmov.i32 q0, #0x0
; FORCE-NEXT:    add.w r8, r7, r0, lsr #2
; FORCE-NEXT:    mov r7, r10
; FORCE-NEXT:    dlstp.32 lr, r4
; FORCE-NEXT:    ldr r0, [sp] @ 4-byte Reload
; FORCE-NEXT:  .LBB0_6: @ %vector.body
; FORCE-NEXT:    @ Parent Loop BB0_4 Depth=1
; FORCE-NEXT:    @ => This Inner Loop Header: Depth=2
; FORCE-NEXT:    vldrh.s32 q1, [r0], #8
; FORCE-NEXT:    vldrh.s32 q2, [r7], #8
; FORCE-NEXT:    mov lr, r8
; FORCE-NEXT:    vmul.i32 q1, q2, q1
; FORCE-NEXT:    sub.w r8, r8, #1
; FORCE-NEXT:    vshl.s32 q1, r5
; FORCE-NEXT:    vadd.i32 q0, q1, q0
; FORCE-NEXT:    letp lr, .LBB0_6
; FORCE-NEXT:  @ %bb.7: @ %middle.block
; FORCE-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCE-NEXT:    vaddv.u32 r0, q0
; FORCE-NEXT:    b .LBB0_3
; FORCE-NEXT:  .LBB0_8: @ %for.end17
; FORCE-NEXT:    add sp, #4
; FORCE-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
;
; NOREDUCTIONS-LABEL: varying_outer_2d_reduction:
; NOREDUCTIONS:       @ %bb.0: @ %entry
; NOREDUCTIONS-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; NOREDUCTIONS-NEXT:    sub sp, #8
; NOREDUCTIONS-NEXT:    cmp r3, #1
; NOREDUCTIONS-NEXT:    str r0, [sp, #4] @ 4-byte Spill
; NOREDUCTIONS-NEXT:    blt .LBB0_8
; NOREDUCTIONS-NEXT:  @ %bb.1: @ %for.body.lr.ph
; NOREDUCTIONS-NEXT:    ldr r0, [sp, #44]
; NOREDUCTIONS-NEXT:    adr r7, .LCPI0_0
; NOREDUCTIONS-NEXT:    ldr.w r10, [sp, #4] @ 4-byte Reload
; NOREDUCTIONS-NEXT:    add.w r9, r2, #3
; NOREDUCTIONS-NEXT:    vldrw.u32 q0, [r7]
; NOREDUCTIONS-NEXT:    mov.w r11, #0
; NOREDUCTIONS-NEXT:    uxth r0, r0
; NOREDUCTIONS-NEXT:    rsbs r5, r0, #0
; NOREDUCTIONS-NEXT:    str.w r9, [sp] @ 4-byte Spill
; NOREDUCTIONS-NEXT:    b .LBB0_4
; NOREDUCTIONS-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    movs r0, #0
; NOREDUCTIONS-NEXT:  .LBB0_3: @ %for.end
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    lsrs r0, r0, #16
; NOREDUCTIONS-NEXT:    sub.w r9, r9, #1
; NOREDUCTIONS-NEXT:    strh.w r0, [r1, r11, lsl #1]
; NOREDUCTIONS-NEXT:    add.w r11, r11, #1
; NOREDUCTIONS-NEXT:    add.w r10, r10, #2
; NOREDUCTIONS-NEXT:    cmp r11, r3
; NOREDUCTIONS-NEXT:    beq .LBB0_8
; NOREDUCTIONS-NEXT:  .LBB0_4: @ %for.body
; NOREDUCTIONS-NEXT:    @ =>This Loop Header: Depth=1
; NOREDUCTIONS-NEXT:    @ Child Loop BB0_6 Depth 2
; NOREDUCTIONS-NEXT:    cmp r2, r11
; NOREDUCTIONS-NEXT:    ble .LBB0_2
; NOREDUCTIONS-NEXT:  @ %bb.5: @ %vector.ph
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    bic r7, r9, #3
; NOREDUCTIONS-NEXT:    movs r6, #1
; NOREDUCTIONS-NEXT:    subs r7, #4
; NOREDUCTIONS-NEXT:    sub.w r0, r2, r11
; NOREDUCTIONS-NEXT:    vmov.i32 q2, #0x0
; NOREDUCTIONS-NEXT:    add.w r8, r6, r7, lsr #2
; NOREDUCTIONS-NEXT:    ldr r7, [sp] @ 4-byte Reload
; NOREDUCTIONS-NEXT:    sub.w r4, r7, r11
; NOREDUCTIONS-NEXT:    movs r7, #0
; NOREDUCTIONS-NEXT:    bic r4, r4, #3
; NOREDUCTIONS-NEXT:    subs r4, #4
; NOREDUCTIONS-NEXT:    add.w r4, r6, r4, lsr #2
; NOREDUCTIONS-NEXT:    subs r6, r0, #1
; NOREDUCTIONS-NEXT:    dls lr, r4
; NOREDUCTIONS-NEXT:    mov r4, r10
; NOREDUCTIONS-NEXT:    ldr r0, [sp, #4] @ 4-byte Reload
; NOREDUCTIONS-NEXT:  .LBB0_6: @ %vector.body
; NOREDUCTIONS-NEXT:    @ Parent Loop BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    @ => This Inner Loop Header: Depth=2
; NOREDUCTIONS-NEXT:    vmov q1, q2
; NOREDUCTIONS-NEXT:    vadd.i32 q2, q0, r7
; NOREDUCTIONS-NEXT:    vdup.32 q3, r7
; NOREDUCTIONS-NEXT:    mov lr, r8
; NOREDUCTIONS-NEXT:    vcmp.u32 hi, q3, q2
; NOREDUCTIONS-NEXT:    vdup.32 q3, r6
; NOREDUCTIONS-NEXT:    vpnot
; NOREDUCTIONS-NEXT:    sub.w r8, r8, #1
; NOREDUCTIONS-NEXT:    vpsttt
; NOREDUCTIONS-NEXT:    vcmpt.u32 cs, q3, q2
; NOREDUCTIONS-NEXT:    vldrht.s32 q2, [r0], #8
; NOREDUCTIONS-NEXT:    vldrht.s32 q3, [r4], #8
; NOREDUCTIONS-NEXT:    adds r7, #4
; NOREDUCTIONS-NEXT:    vmul.i32 q2, q3, q2
; NOREDUCTIONS-NEXT:    vshl.s32 q2, r5
; NOREDUCTIONS-NEXT:    vadd.i32 q2, q2, q1
; NOREDUCTIONS-NEXT:    le lr, .LBB0_6
; NOREDUCTIONS-NEXT:  @ %bb.7: @ %middle.block
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    vpsel q1, q2, q1
; NOREDUCTIONS-NEXT:    vaddv.u32 r0, q1
; NOREDUCTIONS-NEXT:    b .LBB0_3
; NOREDUCTIONS-NEXT:  .LBB0_8: @ %for.end17
; NOREDUCTIONS-NEXT:    add sp, #8
; NOREDUCTIONS-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11, pc}
; NOREDUCTIONS-NEXT:    .p2align 4
; NOREDUCTIONS-NEXT:  @ %bb.9:
; NOREDUCTIONS-NEXT:  .LCPI0_0:
; NOREDUCTIONS-NEXT:    .long 0 @ 0x0
; NOREDUCTIONS-NEXT:    .long 1 @ 0x1
; NOREDUCTIONS-NEXT:    .long 2 @ 0x2
; NOREDUCTIONS-NEXT:    .long 3 @ 0x3
;
; FORCENOREDUCTIONS-LABEL: varying_outer_2d_reduction:
; FORCENOREDUCTIONS:       @ %bb.0: @ %entry
; FORCENOREDUCTIONS-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; FORCENOREDUCTIONS-NEXT:    sub sp, #4
; FORCENOREDUCTIONS-NEXT:    cmp r3, #1
; FORCENOREDUCTIONS-NEXT:    str r0, [sp] @ 4-byte Spill
; FORCENOREDUCTIONS-NEXT:    blt .LBB0_8
; FORCENOREDUCTIONS-NEXT:  @ %bb.1: @ %for.body.lr.ph
; FORCENOREDUCTIONS-NEXT:    ldr r0, [sp, #36]
; FORCENOREDUCTIONS-NEXT:    add.w r12, r2, #3
; FORCENOREDUCTIONS-NEXT:    ldr.w r10, [sp] @ 4-byte Reload
; FORCENOREDUCTIONS-NEXT:    movs r6, #0
; FORCENOREDUCTIONS-NEXT:    mov r9, r12
; FORCENOREDUCTIONS-NEXT:    uxth r0, r0
; FORCENOREDUCTIONS-NEXT:    rsbs r5, r0, #0
; FORCENOREDUCTIONS-NEXT:    b .LBB0_4
; FORCENOREDUCTIONS-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; FORCENOREDUCTIONS-NEXT:    movs r0, #0
; FORCENOREDUCTIONS-NEXT:  .LBB0_3: @ %for.end
; FORCENOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCENOREDUCTIONS-NEXT:    lsrs r0, r0, #16
; FORCENOREDUCTIONS-NEXT:    sub.w r9, r9, #1
; FORCENOREDUCTIONS-NEXT:    strh.w r0, [r1, r6, lsl #1]
; FORCENOREDUCTIONS-NEXT:    adds r6, #1
; FORCENOREDUCTIONS-NEXT:    add.w r10, r10, #2
; FORCENOREDUCTIONS-NEXT:    cmp r6, r3
; FORCENOREDUCTIONS-NEXT:    beq .LBB0_8
; FORCENOREDUCTIONS-NEXT:  .LBB0_4: @ %for.body
; FORCENOREDUCTIONS-NEXT:    @ =>This Loop Header: Depth=1
; FORCENOREDUCTIONS-NEXT:    @ Child Loop BB0_6 Depth 2
; FORCENOREDUCTIONS-NEXT:    cmp r2, r6
; FORCENOREDUCTIONS-NEXT:    ble .LBB0_2
; FORCENOREDUCTIONS-NEXT:  @ %bb.5: @ %vector.ph
; FORCENOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCENOREDUCTIONS-NEXT:    bic r0, r9, #3
; FORCENOREDUCTIONS-NEXT:    movs r7, #1
; FORCENOREDUCTIONS-NEXT:    subs r0, #4
; FORCENOREDUCTIONS-NEXT:    subs r4, r2, r6
; FORCENOREDUCTIONS-NEXT:    vmov.i32 q0, #0x0
; FORCENOREDUCTIONS-NEXT:    add.w r8, r7, r0, lsr #2
; FORCENOREDUCTIONS-NEXT:    mov r7, r10
; FORCENOREDUCTIONS-NEXT:    dlstp.32 lr, r4
; FORCENOREDUCTIONS-NEXT:    ldr r0, [sp] @ 4-byte Reload
; FORCENOREDUCTIONS-NEXT:  .LBB0_6: @ %vector.body
; FORCENOREDUCTIONS-NEXT:    @ Parent Loop BB0_4 Depth=1
; FORCENOREDUCTIONS-NEXT:    @ => This Inner Loop Header: Depth=2
; FORCENOREDUCTIONS-NEXT:    vldrh.s32 q1, [r0], #8
; FORCENOREDUCTIONS-NEXT:    vldrh.s32 q2, [r7], #8
; FORCENOREDUCTIONS-NEXT:    mov lr, r8
; FORCENOREDUCTIONS-NEXT:    vmul.i32 q1, q2, q1
; FORCENOREDUCTIONS-NEXT:    sub.w r8, r8, #1
; FORCENOREDUCTIONS-NEXT:    vshl.s32 q1, r5
; FORCENOREDUCTIONS-NEXT:    vadd.i32 q0, q1, q0
; FORCENOREDUCTIONS-NEXT:    letp lr, .LBB0_6
; FORCENOREDUCTIONS-NEXT:  @ %bb.7: @ %middle.block
; FORCENOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; FORCENOREDUCTIONS-NEXT:    vaddv.u32 r0, q0
; FORCENOREDUCTIONS-NEXT:    b .LBB0_3
; FORCENOREDUCTIONS-NEXT:  .LBB0_8: @ %for.end17
; FORCENOREDUCTIONS-NEXT:    add sp, #4
; FORCENOREDUCTIONS-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
entry:
  %conv = sext i16 %N to i32
  %cmp36 = icmp sgt i16 %N, 0
  br i1 %cmp36, label %for.body.lr.ph, label %for.end17

for.body.lr.ph:                                   ; preds = %entry
  %conv2 = sext i16 %Size to i32
  %conv1032 = zext i16 %Scale to i32
  %i = add i32 %conv2, 3
  br label %for.body

for.body:                                         ; preds = %for.end, %for.body.lr.ph
  %lsr.iv51 = phi i32 [ %lsr.iv.next, %for.end ], [ %i, %for.body.lr.ph ]
  %lsr.iv46 = phi i16* [ %scevgep47, %for.end ], [ %Input, %for.body.lr.ph ]
  %i.037 = phi i32 [ 0, %for.body.lr.ph ], [ %inc16, %for.end ]
  %i1 = mul nsw i32 %i.037, -1
  %i2 = add i32 %i, %i1
  %i3 = lshr i32 %i2, 2
  %i4 = shl nuw i32 %i3, 2
  %i5 = add i32 %i4, -4
  %i6 = lshr i32 %i5, 2
  %i7 = add nuw nsw i32 %i6, 1
  %i8 = sub i32 %conv2, %i.037
  %cmp433 = icmp slt i32 %i.037, %conv2
  br i1 %cmp433, label %vector.ph, label %for.end

vector.ph:                                        ; preds = %for.body
  %trip.count.minus.1 = add i32 %i8, -1
  call void @llvm.set.loop.iterations.i32(i32 %i7)
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %lsr.iv48 = phi i16* [ %scevgep49, %vector.body ], [ %lsr.iv46, %vector.ph ]
  %lsr.iv = phi i16* [ %scevgep, %vector.body ], [ %Input, %vector.ph ]
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %i16, %vector.body ]
  %i9 = phi i32 [ %i7, %vector.ph ], [ %i17, %vector.body ]
  %lsr.iv4850 = bitcast i16* %lsr.iv48 to <4 x i16>*
  %lsr.iv45 = bitcast i16* %lsr.iv to <4 x i16>*
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %trip.count.minus.1)
  %wide.masked.load = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %lsr.iv45, i32 2, <4 x i1> %active.lane.mask, <4 x i16> undef)
  %i10 = sext <4 x i16> %wide.masked.load to <4 x i32>
  %wide.masked.load42 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %lsr.iv4850, i32 2, <4 x i1> %active.lane.mask, <4 x i16> undef)
  %i11 = sext <4 x i16> %wide.masked.load42 to <4 x i32>
  %i12 = mul nsw <4 x i32> %i11, %i10
  %i13 = insertelement <4 x i32> undef, i32 %conv1032, i32 0
  %i14 = shufflevector <4 x i32> %i13, <4 x i32> undef, <4 x i32> zeroinitializer
  %i15 = ashr <4 x i32> %i12, %i14
  %i16 = add <4 x i32> %i15, %vec.phi
  %index.next = add i32 %index, 4
  %scevgep = getelementptr i16, i16* %lsr.iv, i32 4
  %scevgep49 = getelementptr i16, i16* %lsr.iv48, i32 4
  %i17 = call i32 @llvm.loop.decrement.reg.i32(i32 %i9, i32 1)
  %i18 = icmp ne i32 %i17, 0
  br i1 %i18, label %vector.body, label %middle.block

middle.block:                                     ; preds = %vector.body
  %i19 = select <4 x i1> %active.lane.mask, <4 x i32> %i16, <4 x i32> %vec.phi
  %i20 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> %i19)
  br label %for.end

for.end:                                          ; preds = %middle.block, %for.body
  %Sum.0.lcssa = phi i32 [ 0, %for.body ], [ %i20, %middle.block ]
  %i21 = lshr i32 %Sum.0.lcssa, 16
  %conv13 = trunc i32 %i21 to i16
  %arrayidx14 = getelementptr inbounds i16, i16* %Output, i32 %i.037
  store i16 %conv13, i16* %arrayidx14, align 2
  %inc16 = add nuw nsw i32 %i.037, 1
  %scevgep47 = getelementptr i16, i16* %lsr.iv46, i32 1
  %lsr.iv.next = add i32 %lsr.iv51, -1
  %exitcond39 = icmp eq i32 %inc16, %conv
  br i1 %exitcond39, label %for.end17, label %for.body

for.end17:                                        ; preds = %for.end, %entry
  ret void
}

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>*, i32 immarg, <4 x i1>, <4 x i16>)
declare i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32>)
declare i32 @llvm.loop.decrement.reg.i32(i32, i32)
declare void @llvm.set.loop.iterations.i32(i32)
