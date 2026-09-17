set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv32)

if(NOT XTC_LIKE_ROOT AND DEFINED ENV{XTC_LIKE_ROOT})
    set(XTC_LIKE_ROOT "$ENV{XTC_LIKE_ROOT}")
endif()
set(XTC_LIKE_ROOT "${XTC_LIKE_ROOT}" CACHE PATH
    "Root containing the VX4 simulator and runtime tools")

if(NOT RISCV_TOOLCHAIN_ROOT)
    set(RISCV_TOOLCHAIN_ROOT "${XTC_LIKE_ROOT}/riscv32-clang")
endif()
set(RISCV_TOOLCHAIN_ROOT "${RISCV_TOOLCHAIN_ROOT}" CACHE PATH
    "Root of the RISC-V compiler installation")

if(NOT EXISTS "${RISCV_TOOLCHAIN_ROOT}/bin/clang")
    message(FATAL_ERROR
        "RISC-V compiler not found at ${RISCV_TOOLCHAIN_ROOT}/bin/clang")
endif()

set(CMAKE_C_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/clang")
set(CMAKE_CXX_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/clang++")
set(CMAKE_ASM_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/clang")

set(CMAKE_C_COMPILER_TARGET riscv32-xmos-unknown-elf)
set(CMAKE_CXX_COMPILER_TARGET riscv32-xmos-unknown-elf)
set(CMAKE_ASM_COMPILER_TARGET riscv32-xmos-unknown-elf)

set(CMAKE_C_FLAGS_INIT
    "-mcpu=xmos-vx4b -D__VX4B__ -msmall-data-limit=8")
set(CMAKE_CXX_FLAGS_INIT
    "-mcpu=xmos-vx4b -D__VX4B__ -msmall-data-limit=8")
set(CMAKE_ASM_FLAGS_INIT "-mcpu=xmos-vx4b -D__VX4B__")
set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-mcpu=xmos-vx4b -lxcore -lrom -Wl,--relax-gp")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
    XTC_LIKE_ROOT
    RISCV_TOOLCHAIN_ROOT
)
