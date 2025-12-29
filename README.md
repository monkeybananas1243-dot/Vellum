# **PeltOS**
This is PeltOS, a custom-built operating system focused on low-level hardware interaction
and kernel development. It currently serves as a foundational environment, booting directly
into a stable text-mode state.

**This is my first time coding an OS, so don't flame me for bad code.**

## Development Stage
The project is currently in the **Kernel Initialization Phase**. 
The system successfully transitions from the bootloader to the kernel, 
initializes primary hardware structures, and prepares the display for user interaction.

## Features
* **32-bit Protected Mode**: Successfully transitions from Real Mode to exploit full 32-bit CPU capabilities.
* **VGA Text-Mode Driver**: Custom driver supporting an 80 x 25 terminal with scrolling and color support.
* **GDT & Stack Setup**: Properly initialized Global Descriptor Table and kernel stack for stable C execution.

## If you wish to try it out
### Requirements
Before running the scripts, ensure you have the following installed and added to your system PATH:
* **NASM** (Assembler)
* **QEMU** (Emulator)
* **i686-elf-gcc** (Cross-Compiler)
* **Make** (Build Tool) (Optional)

## How to use it
All automation scripts are located in the `bat/` folder or handled via the `Makefile`.

### **For Windows Users (No Make)**
Open a Command Prompt, navigate to the root of the project, and run:

```batch
cd bat
setup
build
```

### **For Windows Users (With Make)**

```batch
cd bat
env
make
```

### **For Linux/Mac Users**

```bash
make
```

## **Running the OS**

### **For Windows Users (No Make)**

```batch
cd bat
run
```

### **For Windows Users (With Make)**

```batch
make run
```

### **For Linux/Mac Users**

```bash
make run
```
