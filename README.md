# rustech-os
RustechOS - My OS that i created in 2026(im 11 now)

# How does it work

## 💾 Boot Sequence (The RAM Takeover)

1. **BIOS Boot (`0x7C00`)**: When the PC powers on, the BIOS loads `boot.bin` (the first 512 bytes from the disk) into RAM at address `0x7C00` and executes it.
2. **Kernel Loading (`0x1000`)**: The bootloader initializes the stack and calls BIOS `int 0x13` to read the second sector from the disk (`kernel.bin`) and copy it into RAM at address `0x1000`.
3. **Protected Mode Switch**: The bootloader disables 16-bit interrupts (`cli`), loads the Global Descriptor Table (`gdt.asm`), flips the CR0 register bit, and performs a long jump into 32-bit Protected Mode.
4. **The Assembly Bridge**: The processor lands on `kernel_entry.asm` which calls the `main()` function inside our C code.

## 🛠️ The IOsys Engine

Inside `kernel.c`, the OS runs an independent input/output loop without any Linux or Windows standard libraries:
* **Output**: Writes raw bytes directly to the VGA text video memory at `0xB8000`. 
* **Input**: Runs a continuous hardware poll on port `0x60`. When you press **SPACE** (scancode `0x39`), the C kernel instantly catches it from the motherboard and reveals the yellow `sys_info` status string!

---

## 🧰 Portable Toolbox Included!
* **Zero Setup**: The NASM compiler (`nasm.exe`) is already included directly inside the repository toolbox. 
* No need to configure system PATH variables or install global packages. Just clone and fire!


## 🚀 How to Build & Run (LLVM Dragon Combo)

You don't need heavy Linux virtual machines anymore. Build **RUSTECH OS** directly in Windows using the modern LLVM toolchain:

```powershell
# 1. Compile the Assembly bootloader and the bridge
./nasm boot.asm -f bin -o boot.bin
./nasm kernel_entry.asm -f elf32 -o kernel_entry.o

# 2. Compile the C Kernel via Clang (Bare Metal Target)
clang -m32 -ffreestanding -target i386-unknown-none-code -c kernel.c -o kernel.o

# 3. Link everything using LLD (Strips all ELF metadata)
ld.lld -m elf_i386 -Ttext 0x1000 -e _start --oformat=binary kernel_entry.o kernel.o -o kernel.bin

# 4. Bake the final disk image and Fire up QEMU!
cmd /c "copy /b boot.bin+kernel.bin os-image.bin"
qemu-system-x86_64 -drive format=raw,file=os-image.bin
```

## 📜 License
Licensed under the **Apache License 2.0**. Free to use, modify, and share. Do not sell! 🌾❌
