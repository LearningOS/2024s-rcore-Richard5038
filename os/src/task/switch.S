.altmacro
.macro SAVE_SN n
    sd s\n, (\n+2)*8(a0) //保存寄存器s\n到a0指向的地址
.endm
.macro LOAD_SN n
    ld s\n, (\n+2)*8(a1)//从a1指向的地址中加载寄存器s\n
.endm
    .section .text//指定代码段
    .globl __switch//声明全局符号
__switch://切换上下文的函数
    # __switch(
    #     current_task_cx_ptr: *mut TaskContext,
    #     next_task_cx_ptr: *const TaskContext
    # )
    # save kernel stack of current task
    sd sp, 8(a0)
    # save ra（返回地址） & s0~s11 of current execution
    sd ra, 0(a0)
    .set n, 0
    .rept 12
        SAVE_SN %n //宏SAVE_SN保存s0-s11
        .set n, n + 1
    .endr
    # restore ra & s0~s11 of next execution
    ld ra, 0(a1)
    .set n, 0
    .rept 12
        LOAD_SN %n//加载s0-s11
        .set n, n + 1
    .endr
    # restore kernel stack of next task
    ld sp, 8(a1)
    ret

